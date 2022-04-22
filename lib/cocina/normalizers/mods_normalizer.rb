# frozen_string_literal: true
require 'deprecation'

module Cocina
  module Normalizers
    # Normalizes a Fedora MODS document, accounting for differences between Fedora MODS and MODS generated from Cocina.
    # these adjustments have been approved by our metadata authority, Arcadia.
    class ModsNormalizer # rubocop:disable Metrics/ClassLength
      include Cocina::Normalizers::Base
      extend Deprecation

      MODS_NS = Cocina::FromFedora::Descriptive::DESC_METADATA_NS
      XLINK_NS = Cocina::FromFedora::Descriptive::XLINK_NS

      # @param [Nokogiri::Document] mods_ng_xml MODS to be normalized
      # @param [String] druid
      # @param [String] label
      # @param [String] purl
      # @param [Proc] is_purl
      # @return [Nokogiri::Document] normalized MODS
      def self.normalize(mods_ng_xml:, druid:, label:, purl: nil, is_purl: nil)
        Deprecation.warn(self, "Calling normalize without passing 'purl:' is deprecated and will be removed in 1.0") unless purl
        purl ||= Cocina::FromFedora::Purl.for(druid: druid)

        Deprecation.warn(self, "Calling normalize without passing 'is_purl:' is deprecated and will be removed in 1.0") unless is_purl
        is_purl ||= ->(val) { FromFedora::Purl.purl?(val) }
        new(mods_ng_xml: mods_ng_xml, druid: druid, label: label, purl: purl, is_purl: is_purl).normalize
      end

      # @param [Nokogiri::Document] mods_ng_xml MODS to be normalized
      # @param [String] druid
      # @param [String] purl
      # @param [Proc] is_purl
      # @return [Nokogiri::Document] normalized MODS
      def self.normalize_purl(mods_ng_xml:, druid:, purl: nil, is_purl: nil)
        Deprecation.warn(self, "Calling normalize_purl without passing 'purl:'' is deprecated and will be removed in 1.0") unless purl
        purl ||= Cocina::FromFedora::Purl.for(druid: druid)

        Deprecation.warn(self, "Calling normalize_purl without passing 'is_purl:' is deprecated and will be removed in 1.0") unless is_purl
        is_purl ||= ->(val) { FromFedora::Purl.purl?(val) }
        new(mods_ng_xml: mods_ng_xml, druid: druid, purl: purl, is_purl: is_purl).normalize_purl
      end

      # @param [Nokogiri::Document] mods_ng_xml MODS to be normalized
      # @param [String] druid
      # @param [String] label
      # @return [Nokogiri::Document] normalized MODS
      def self.normalize_purl_and_missing_title(mods_ng_xml:, druid:, label:, purl: nil, is_purl: nil)
        Deprecation.warn(self, "Calling normalize_purl_and_missing_title without passing 'purl:' is deprecated and will be removed in 1.0") unless purl
        purl ||= Cocina::FromFedora::Purl.for(druid: druid)

        Deprecation.warn(self, "Calling normalize_purl without passing 'is_purl:' is deprecated and will be removed in 1.0") unless is_purl
        is_purl ||= ->(val) { FromFedora::Purl.purl?(val) }
        new(mods_ng_xml: mods_ng_xml, druid: druid, label: label, purl: purl, is_purl: is_purl).normalize_purl_and_missing_title
      end

      # @param [Nokogiri::Document] mods_ng_xml MODS to be normalized
      # @return [Nokogiri::Document] normalized MODS
      def self.normalize_identifier_type(mods_ng_xml:)
        new(mods_ng_xml: mods_ng_xml, druid: nil, purl: nil, is_purl: nil).normalize_identifier_type
      end

      def initialize(mods_ng_xml:, druid:, purl:, is_purl:, label: nil)
        @ng_xml = mods_ng_xml.root ? mods_ng_xml.dup : blank_ng_xml
        @ng_xml.encoding = 'UTF-8'
        @druid = druid
        @purl = purl
        @is_purl = is_purl
        @label = label
      end

      def normalize
        normalize_default_namespace
        normalize_xsi
        normalize_version
        normalize_empty_attributes
        normalize_authority_uris # must be called before OriginInfoNormalizer
        @ng_xml = Cocina::Normalizers::Mods::OriginInfoNormalizer.normalize(mods_ng_xml: ng_xml)
        @ng_xml = Cocina::Normalizers::Mods::SubjectNormalizer.normalize(mods_ng_xml: ng_xml)
        @ng_xml = Cocina::Normalizers::Mods::NameNormalizer.normalize(mods_ng_xml: ng_xml)
        normalize_related_item_other_type
        normalize_unmatched_altrepgroup
        normalize_unmatched_nametitlegroup
        normalize_xml_space
        normalize_language_term_type
        normalize_access_condition
        normalize_identifier_type_attr
        normalize_location_physical_location
        normalize_purl_location
        normalize_empty_notes
        @ng_xml = Cocina::Normalizers::Mods::TitleNormalizer.normalize(mods_ng_xml: ng_xml, label: label)
        @ng_xml = Cocina::Normalizers::Mods::GeoExtensionNormalizer.normalize(mods_ng_xml: ng_xml, druid: druid)
        normalize_empty_type_of_resource # Must be after normalize_empty_attributes
        normalize_notes
        normalize_abstracts
        normalize_usage_primary
        normalize_related_item_attributes
        # This should be last-ish.
        normalize_empty_related_items
        remove_empty_elements(ng_xml.root) # this must be last
        ng_xml
      end

      def normalize_purl
        normalize_purl_location
        ng_xml
      end

      def normalize_purl_and_missing_title
        normalize_purl_location
        @ng_xml = Cocina::Normalizers::Mods::TitleNormalizer.normalize_missing_title(mods_ng_xml: ng_xml, label: label)
        ng_xml
      end

      def normalize_identifier_type
        normalize_identifier_type_attr
        ng_xml
      end

      private

      attr_reader :ng_xml, :druid, :purl, :label

      # remove all empty elements that have no attributes and no children, recursively
      def remove_empty_elements(start_node)
        return unless start_node

        # remove node if there are no element children, there is no text value and there are no attributes
        if start_node.elements.size.zero? &&
           start_node.text.blank? &&
           start_node.attributes.size.zero? &&
           start_node.name != 'etal'
          parent = start_node.parent
          start_node.remove
          remove_empty_elements(parent) # need to call again after child has been deleted
        else
          start_node.element_children.each { |e| remove_empty_elements(e) }
        end
      end

      def normalize_default_namespace
        xml = ng_xml.to_s

        unless xml.include?('xmlns="http://www.loc.gov/mods/v3"')
          xml.sub!('mods:mods', 'mods:mods xmlns="http://www.loc.gov/mods/v3"')
          xml.gsub!('mods:', '')
        end

        regenerate_ng_xml(xml)
      end

      def normalize_xsi
        return if ng_xml.namespaces.include?('xmlns:xsi')

        xml = ng_xml.to_s
        xml.sub!('<mods ', '<mods xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" ')

        regenerate_ng_xml(xml)
      end

      def normalize_version
        # Only normalize version when version isn't mapped.
        match = /MODS version (\d\.\d)/.match(ng_xml.at('//mods:recordInfo/mods:recordOrigin', mods: MODS_NS)&.content)

        if !match
          ng_xml.root['version'] = '3.7'
          ng_xml.root['xsi:schemaLocation'] = 'http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd'
        elsif match && match[1] != ng_xml.root['version']
          ng_xml.root['version'] = match[1]
          ng_xml.root['xsi:schemaLocation'] = "http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-#{match[1].sub('.', '-')}.xsd"
        end
      end

      def normalize_authority_uris
        Cocina::FromFedora::Descriptive::Authority::NORMALIZE_AUTHORITY_URIS.each do |authority_uri|
          ng_xml.xpath("//mods:*[@authorityURI='#{authority_uri}']", mods: MODS_NS).each do |node|
            node[:authorityURI] = "#{authority_uri}/"
          end
        end
      end

      def normalize_purl_location
        normalize_purl_for(ng_xml.root, purl: purl)
        ng_xml.xpath('/mods:mods/mods:relatedItem', mods: MODS_NS).each { |related_item_node| normalize_purl_for(related_item_node) }
      end

      def normalize_purl_for(base_node, purl: nil)
        purl_nodes(base_node).each do |purl_node|
          purl_node.content = FromFedora::Descriptive::Purl.purl_value(purl_node)
        end

        # If there is a purl, add a url node if there is not already one.
        if purl && purl_nodes(base_node).to_a.none? { |purl_node| purl_node.content == purl }
          new_location = Nokogiri::XML::Node.new('location', Nokogiri::XML(nil))
          new_url = Nokogiri::XML::Node.new('url', Nokogiri::XML(nil))
          new_url.content = purl
          new_location << new_url
          base_node << new_location
        end

        purl_nodes(base_node).each do |purl_node|
            next if purl_node == Cocina::FromFedora::Descriptive::Purl.primary_purl_node(base_node, purl)

          # Move into own relatedItem
          new_related_item = Nokogiri::XML::Node.new('relatedItem', Nokogiri::XML(nil))
          location_node = purl_node.parent
          location_node.remove
          new_related_item << location_node
          base_node << new_related_item
          purl_node[:usage] = 'primary display'
        end

        primary_url_node = primary_url_node_for(base_node, purl)
        base_node.xpath('mods:location/mods:url', mods: MODS_NS).each do |url_node|
          if url_node == primary_url_node
            url_node[:usage] = 'primary display'
          elsif url_node[:usage] == 'primary display'
            url_node.delete('usage')
          end
        end
      end

      def purl_nodes(base_node)
        base_node.xpath('mods:location/mods:url', mods: MODS_NS).select { |url_node| purl?(url_node.text) }
      end

      def purl?(value)
        @is_purl.call(value)
      end

      def primary_url_node_for(base_node, purl)
        primary_purl_nodes, primary_url_nodes = base_node.xpath('mods:location/mods:url[@usage="primary display"]', mods: MODS_NS)
                                                         .partition { |url_node| purl?(url_node.text) }
        all_purl_nodes = base_node.xpath('mods:location/mods:url', mods: MODS_NS)
                                  .select { |url_node| purl?(url_node.text) }

        this_purl_node = purl ? all_purl_nodes.find { |purl_node| purl_node.content == purl } : nil

        primary_purl_nodes.first || primary_url_nodes.first || this_purl_node || all_purl_nodes.first
      end

      def normalize_related_item_other_type
        ng_xml.xpath('//mods:relatedItem[@type and @otherType]', mods: MODS_NS).each do |related_node|
          related_node.delete('otherType')
          related_node.delete('otherTypeURI')
          related_node.delete('otherTypeAuth')
        end
      end

      def normalize_empty_notes
        ng_xml.xpath('//mods:note[not(text()) and not(@xlink:href)]', mods: MODS_NS, xlink: XLINK_NS).each(&:remove)
      end

      def normalize_empty_type_of_resource
        ng_xml.xpath('//mods:typeOfResource[not(text())][not(@*)]', mods: MODS_NS).each(&:remove)
      end

      def normalize_unmatched_altrepgroup
        normalize_unmatched_altrepgroup_for(ng_xml.root)
        ng_xml.xpath('//mods:relatedItem', mods: MODS_NS).each { |related_item_node| normalize_unmatched_altrepgroup_for(related_item_node) }
      end

      def normalize_unmatched_altrepgroup_for(base_node)
        ids = {}
        base_node.xpath('mods:*[@altRepGroup]', mods: MODS_NS).each do |node|
          id = [node['altRepGroup'], node.name]
          ids[id] ||= []
          ids[id] << node
        end

        ids.each_value do |nodes|
          next unless nodes.size == 1

          nodes.first.delete('altRepGroup')
        end
      end

      def normalize_unmatched_nametitlegroup
        normalize_unmatched_nametitlegroup_for(ng_xml.root)
        ng_xml.xpath('//mods:relatedItem', mods: MODS_NS).each { |related_item_node| normalize_unmatched_nametitlegroup_for(related_item_node) }
      end

      def normalize_unmatched_nametitlegroup_for(base_node)
        ids = {}
        base_node.xpath('mods:name[@nameTitleGroup] | mods:titleInfo[@nameTitleGroup]', mods: MODS_NS).each do |node|
          id = node['nameTitleGroup']
          ids[id] ||= []
          ids[id] << node
        end

        ids.each_value do |nodes|
          next unless nodes.size == 1

          nodes.first.delete('nameTitleGroup')
        end
      end

      def normalize_empty_attributes
        ng_xml.xpath('//mods:*[@*=""]', mods: MODS_NS).each do |node|
          node.each { |attr_name, attr_value| node.delete(attr_name) if attr_value.blank? }
        end
      end

      def normalize_xml_space
        ng_xml.xpath('//mods:*[@xml:space]', mods: MODS_NS).each do |node|
          node.delete('space')
        end
      end

      def normalize_language_term_type
        ng_xml.xpath('//mods:languageTerm[not(@type)]', mods: MODS_NS).each do |node|
          node['type'] = 'code'
        end
      end

      def normalize_access_condition
        ng_xml.xpath('//mods:accessCondition[@type="restrictionOnAccess"]', mods: MODS_NS).each do |node|
          node['type'] = 'restriction on access'
        end
        ng_xml.xpath('//mods:accessCondition[@type="restrictionsOnAccess"]', mods: MODS_NS).each do |node|
          node['type'] = 'restriction on access'
        end
        ng_xml.xpath('//mods:accessCondition[@type="useAndReproduction"]', mods: MODS_NS).each do |node|
          node['type'] = 'use and reproduction'
        end
      end

      def normalize_identifier_type_attr
        ng_xml.xpath('//mods:identifier[@type]', mods: MODS_NS).each do |node|
          node['type'] = normalized_identifier_type_for(node['type'])
        end
        ng_xml.xpath('//mods:nameIdentifier[@type]', mods: MODS_NS).each do |node|
          node['type'] = normalized_identifier_type_for(node['type'])
        end
        ng_xml.xpath('//mods:recordIdentifier[@source]', mods: MODS_NS).each do |node|
          node['source'] = normalized_identifier_type_for(node['source'])
        end
      end

      def normalized_identifier_type_for(type)
        cocina_type, _mods_type, identifier_source = Cocina::FromFedora::Descriptive::IdentifierType.cocina_type_for_mods_type(type)

        return Cocina::FromFedora::Descriptive::IdentifierType.mods_type_for_cocina_type(cocina_type) if identifier_source

        type
      end

      def normalize_location_physical_location
        ng_xml.xpath('//mods:location', mods: MODS_NS).each do |location_node|
          location_node.xpath('mods:physicalLocation|mods:url|mods:shelfLocator', mods: MODS_NS).each do |node|
            next unless node.content.present? || node['xlink:href']

            new_location = Nokogiri::XML::Node.new('location', ng_xml)
            new_location << node
            location_node.parent << new_location
          end
          location_node.remove
        end
      end

      def normalize_empty_related_items
        ng_xml.xpath('//mods:relatedItem/mods:part[count(mods:*)=1]/mods:detail[count(mods:*)=1]/mods:number[not(text())]',
                     mods: MODS_NS).each do |number_node|
          number_node.parent.parent.remove
        end
        ng_xml.xpath('//mods:relatedItem[not(mods:*) and not(@xlink:href)]', mods: MODS_NS, xlink: XLINK_NS).each(&:remove)
      end

      def normalize_notes
        ng_xml.xpath('//mods:note', mods: MODS_NS).each do |note_node|
          if ToFedora::Descriptive::Note.note_type_to_abstract_type.include?(note_node['type']&.downcase) ||
             ToFedora::Descriptive::Note.display_label_to_abstract_type.include?(note_node['displayLabel'])
            note_node.delete('type') unless note_node['type']&.downcase == 'summary'
            note_node.name = 'abstract'
          end
          if ToFedora::Descriptive::Note.display_label_to_abstract_type.include? note_node['displayLabel']
            note_node['displayLabel'] =
              note_node['displayLabel'].capitalize
          end
        end
      end

      def normalize_abstracts
        ng_xml.xpath('/mods:mods/mods:abstract', mods: MODS_NS).each do |abstract_node|
          if ToFedora::Descriptive::Note.note_type_to_abstract_type.include? abstract_node['type']&.downcase
            abstract_node['type'] =
              abstract_node['type'].downcase
          end
          if ToFedora::Descriptive::Note.display_label_to_abstract_type.include? abstract_node['displayLabel']
            abstract_node['displayLabel'] =
              abstract_node['displayLabel'].capitalize
          end
          abstract_node.delete('type') if abstract_node['type'] == 'abstract'
        end
      end

      def normalize_usage_primary
        normalize_usage_primary_for(ng_xml.root)
        ng_xml.xpath('/mods:mods/mods:relatedItem', mods: ModsNormalizer::MODS_NS).each do |related_item_node|
          normalize_usage_primary_for(related_item_node)
        end
        ng_xml.xpath('//mods:subject', mods: ModsNormalizer::MODS_NS).each { |subject_node| normalize_usage_primary_for(subject_node) }
      end

      def normalize_usage_primary_for(base_node)
        %w[genre language classification subject titleInfo typeOfResource name].each do |node_name|
          primary_nodes = base_node.xpath("mods:#{node_name}[@usage=\"primary\"]", mods: MODS_NS)
          next if primary_nodes.size < 2

          primary_nodes[1..].each { |primary_node| primary_node.delete('usage') }
        end
      end

      def normalize_related_item_attributes
        ng_xml.xpath('/mods:mods/mods:relatedItem[@lang or @script]', mods: ModsNormalizer::MODS_NS).each do |related_item_node|
          related_item_node.delete('lang')
          related_item_node.delete('script')
        end
      end

      def blank_ng_xml
        Nokogiri::XML(<<~XML
          <mods xmlns="http://www.loc.gov/mods/v3"#{' '}
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"#{' '}
            version="3.6"#{' '}
            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-6.xsd" />
        XML
                     )
      end
    end
  end
end
