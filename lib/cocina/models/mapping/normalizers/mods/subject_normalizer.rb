# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module Normalizers
        module Mods
          # Normalizes a Fedora MODS document for subject elements.
          class SubjectNormalizer # rubocop:disable Metrics/ClassLength
            # @param [Nokogiri::Document] mods_ng_xml MODS to be normalized
            # @return [Nokogiri::Document] normalized MODS
            def self.normalize(mods_ng_xml:)
              new(mods_ng_xml: mods_ng_xml).normalize
            end

            def initialize(mods_ng_xml:)
              @ng_xml = mods_ng_xml.dup
              @ng_xml.encoding = 'UTF-8'
            end

            def normalize
              normalize_xlink_href
              normalize_empty_geographic
              normalize_marcgac
              normalize_empty_temporal
              normalize_subject
              normalize_subject_children
              normalize_subject_authority
              normalize_subject_authority_lcnaf
              normalize_subject_authority_naf
              normalize_subject_authority_tgm
              normalize_coordinates # Must be before normalize_subject_cartographics
              normalize_subject_cartographics
              normalize_subject_lang_and_script
              ng_xml
            end

            private

            attr_reader :ng_xml

            def normalize_marcgac
              ng_xml.root.xpath('//mods:geographicCode', mods: ModsNormalizer::MODS_NS).each do |node|
                node.content = node.content.sub(/-+$/, '')
              end
            end

            # rubocop:disable Metrics/CyclomaticComplexity
            # rubocop:disable Metrics/AbcSize
            def normalize_subject
              ng_xml.root.xpath('//mods:subject[not(mods:cartographics)]', mods: ModsNormalizer::MODS_NS).each do |subject_node|
                children_nodes = subject_node.xpath('mods:*', mods: ModsNormalizer::MODS_NS)

                next if children_nodes.empty?

                if (have_authorityURI?(subject_node) || have_valueURI?(subject_node)) &&
                   children_nodes.size == 1
                  # If subject has authority and child doesn't, copy to child.
                  add_authority(children_nodes, subject_node) if have_authority?(subject_node) && !have_authority?(children_nodes)
                  # If subject has authorityURI and child doesn't, move to child.
                  add_authorityURI(children_nodes, subject_node) if have_authorityURI?(subject_node) && !have_authorityURI?(children_nodes)
                  subject_node.delete('authorityURI')
                  # If subject has valueURI and child doesn't, move to child.
                  add_valueURI(children_nodes, subject_node) if have_valueURI?(subject_node) && !have_valueURI?(children_nodes)
                  subject_node.delete('valueURI')
                end

                if !have_authority?(subject_node) &&
                   have_authority?(children_nodes.first) &&
                   have_same_authority?(children_nodes, children_nodes.first)
                  add_authority(subject_node, children_nodes.first, naf_to_lcsh: true)
                end

                next unless have_authority?(subject_node) &&
                            have_authorityURI?(subject_node) &&
                            !have_valueURI?(subject_node) &&
                            have_authority?(children_nodes.first) &&
                            have_same_authority?(children_nodes, children_nodes.first)

                delete_authorityURI(subject_node)
              end
            end

            def normalize_subject_children
              ng_xml.root.xpath('//mods:subject[not(mods:cartographics)]', mods: ModsNormalizer::MODS_NS).each do |subject_node|
                children_nodes = subject_node.xpath('mods:*', mods: ModsNormalizer::MODS_NS)

                children_nodes.each do |child_node|
                  next unless !have_authorityURI?(subject_node) &&
                              !have_valueURI?(subject_node) &&
                              have_authority?(child_node) &&
                              have_same_authority?(child_node, subject_node) &&
                              child_node['authority'] != 'naf' &&
                              !(have_authorityURI?(child_node) || have_valueURI?(child_node))

                  delete_authority(child_node)
                end

                next unless !have_authorityURI?(subject_node) &&
                            !have_valueURI?(subject_node) &&
                            have_authority?(subject_node) &&
                            !have_authority?(children_nodes) &&
                            (have_authorityURI?(children_nodes) || have_valueURI?(children_nodes))

                add_authority(children_nodes, subject_node)
              end
            end
            # rubocop:enable Metrics/CyclomaticComplexity
            # rubocop:enable Metrics/AbcSize

            def have_authority?(nodes)
              nodes_to_a(nodes).all? { |node| node[:authority] }
            end

            def have_same_authority?(nodes, same_node)
              nodes_to_a(nodes).all? { |node| same_node[:authority] == node[:authority] || (lcsh_or_naf?(same_node) && lcsh_or_naf?(node)) }
            end

            def lcsh_or_naf?(node)
              %w[lcsh naf].include?(node[:authority])
            end

            def add_authority(nodes, from_node, naf_to_lcsh: false)
              authority = if naf_to_lcsh && from_node[:authority] == 'naf'
                            'lcsh'
                          else
                            from_node[:authority]
                          end
              nodes_to_a(nodes).each { |node| node[:authority] = authority }
            end

            def delete_authority(nodes)
              nodes_to_a(nodes).each { |node| node.delete('authority') }
            end

            # rubocop:disable Naming/MethodName
            def have_authorityURI?(nodes)
              nodes_to_a(nodes).all? { |node| node[:authorityURI] }
            end

            def add_authorityURI(nodes, from_node)
              nodes_to_a(nodes).each { |node| node[:authorityURI] = from_node[:authorityURI] }
            end

            def delete_authorityURI(nodes)
              nodes_to_a(nodes).each { |node| node.delete('authorityURI') }
            end

            def have_valueURI?(nodes)
              nodes_to_a(nodes).all? { |node| node[:valueURI] }
            end

            def add_valueURI(nodes, from_node)
              nodes_to_a(nodes).each { |node| node[:valueURI] = from_node[:valueURI] }
            end
            # rubocop:enable Naming/MethodName

            def nodes_to_a(nodes)
              nodes.is_a?(Nokogiri::XML::NodeSet) ? nodes : [nodes]
            end

            def normalize_subject_authority
              ng_xml.root.xpath('//mods:subject[not(@authority) and count(mods:*) = 1 and not(mods:geographicCode)]/mods:*[@authority and @authority != "naf"]',
                                mods: ModsNormalizer::MODS_NS).each do |node|
                node.parent['authority'] = node['authority']
                node.delete('authority') unless node['authorityURI'] || node['valueURI']
              end
            end

            def normalize_subject_authority_lcnaf
              ng_xml.root.xpath("//mods:*[@authority='lcnaf']", mods: ModsNormalizer::MODS_NS).each do |node|
                node[:authority] = 'naf'
              end
            end

            def normalize_subject_authority_tgm
              ng_xml.root.xpath("//mods:*[@authority='tgm']", mods: ModsNormalizer::MODS_NS).each do |node|
                node[:authority] = 'lctgm'
              end
            end

            def normalize_coordinates
              ng_xml.root.xpath('//mods:coordinates[text()]', mods: ModsNormalizer::MODS_NS).each do |coordinate_node|
                coordinate_node.content = coordinate_node.content.delete_prefix('(').delete_suffix(')')
              end
            end

            # Collapse multiple subject/cartographics nodes into a single one
            def normalize_subject_cartographics
              normalize_subject_cartographics_for(ng_xml.root)
              ng_xml.root.xpath('mods:relatedItem', mods: ModsNormalizer::MODS_NS).each do |related_item_node|
                normalize_subject_cartographics_for(related_item_node)
              end
            end

            def normalize_subject_cartographics_for(root_node)
              carto_subject_nodes = root_node.xpath('mods:subject[not(@altRepGroup)][mods:cartographics]', mods: ModsNormalizer::MODS_NS)
              return if carto_subject_nodes.empty?

              # Create a default carto subject.
              default_carto_subject_node = Nokogiri::XML::Node.new('subject', Nokogiri::XML(nil))
              default_carto_node = Nokogiri::XML::Node.new('cartographics', Nokogiri::XML(nil))
              default_carto_subject_node << default_carto_node

              carto_subject_nodes.each do |carto_subject_node|
                carto_subject_node.xpath('mods:cartographics', mods: ModsNormalizer::MODS_NS).each do |carto_node|
                  normalize_cartographic_node(carto_node, carto_subject_node, default_carto_node)
                end
                carto_subject_node.remove if carto_subject_node.elements.empty?
              end

              root_node << default_carto_subject_node if default_carto_node.elements.present?
            end

            # Normalizes a single cartographic node
            def normalize_cartographic_node(carto_node, carto_subject_node, default_carto_node)
              child_nodes = if carto_subject_node['authority'] || carto_subject_node['authorityURI'] || carto_subject_node['valueURI']
                              # Move scale and coordinates to default carto subject.
                              carto_node.xpath('mods:scale',
                                               mods: ModsNormalizer::MODS_NS) + carto_node.xpath('mods:coordinates', mods: ModsNormalizer::MODS_NS)
                            else
                              # Merge all into default carto_subject.
                              carto_node.elements
                            end

              child_nodes.each do |child_node|
                child_node.remove
                next if child_node.children.blank? # skip empty nodes

                default_carto_node << child_node unless child_node_exists?(child_node, default_carto_node)
              end
              carto_node.remove if carto_node.elements.empty?
            end

            def child_node_exists?(child_node, parent_node)
              parent_node.elements.any? { |check_node| child_node.name == check_node.name && child_node.content == check_node.content }
            end

            def normalize_subject_authority_naf
              ng_xml.root.xpath("//mods:subject[@authority='naf']", mods: ModsNormalizer::MODS_NS).each do |subject_node|
                subject_node[:authority] = 'lcsh'
              end
            end

            def normalize_subject_lang_and_script
              ng_xml.root.xpath('//mods:subject[mods:*]', mods: ModsNormalizer::MODS_NS).each do |subject_node|
                check_child_node = subject_node.elements.first
                # If all children have the same lang, then move to subject and delete from children.
                check_lang = check_child_node['lang']
                if check_lang && subject_node.elements.all? { |child_node| child_node['lang'] == check_lang }
                  subject_node['lang'] = check_lang
                  subject_node.elements.each { |child_node| child_node.delete('lang') }
                end

                # If all children have the same script, then move to subject and delete from children.
                check_script = check_child_node['script']
                if check_script && subject_node.elements.all? { |node| node['script'] == check_script }
                  subject_node['script'] = check_script
                  subject_node.elements.each { |child_node| child_node.delete('script') }
                end
              end
            end

            def normalize_empty_temporal
              ng_xml.root.xpath('//mods:subject/mods:temporal[not(text())]', mods: ModsNormalizer::MODS_NS).each do |temporal_node|
                subject_node = temporal_node.parent
                temporal_node.remove
                subject_node.remove if subject_node.elements.empty?
              end
            end

            def normalize_empty_geographic
              ng_xml.root.xpath('//mods:subject/mods:geographic[not(@valueURI) and not(text())]', mods: ModsNormalizer::MODS_NS).each do |geo_node|
                subject_node = geo_node.parent
                geo_node.remove
                subject_node.remove if subject_node.elements.empty? && subject_node.attributes.empty?
              end
            end

            def normalize_xlink_href
              ng_xml.root.xpath('//mods:subject/mods:*[@xlink:href]', mods: ModsNormalizer::MODS_NS, xlink: ModsNormalizer::XLINK_NS).each do |child_node|
                subject_node = child_node.parent
                subject_node['xlink:href'] = child_node['xlink:href']
                child_node.delete('href')
              end
            end
          end
        end
      end
    end
  end
end
