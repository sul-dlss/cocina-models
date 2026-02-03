# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMods
        # Creates Cocina Description objects from MODS xml
        class Description
          DESC_METADATA_NS = 'http://www.loc.gov/mods/v3'
          XLINK_NS = 'http://www.w3.org/1999/xlink'

          # @param [Nokogiri::XML] mods
          # @param [String] druid
          # @oaram [String] label
          # @param [TitleBuilder] title_builder - defaults to Title class
          # @param [Cocina::Models::Mapping::ErrorNotifier] notifier
          # @return [Hash] a hash that can be mapped to a cocina descriptive model
          def self.props(mods:, druid:, label:, title_builder: Title, notifier: nil)
            new(title_builder: title_builder, mods: mods, druid: druid, label: label, notifier: notifier).props
          end

          def initialize(title_builder:, mods:, label:, druid:, notifier:)
            @title_builder = title_builder
            @ng_xml = mods
            @notifier = notifier || ErrorNotifier.new(druid: druid)
            @druid = druid
            @label = label
          end

          # @return [Hash] a hash that can be mapped to a cocina descriptive model
          # @raises [Cocina::Mapper::InvalidDescMetadata] if some assumption about descMetadata is violated
          def props
            return nil if ng_xml.root.nil?

            check_altrepgroups
            check_version
            props = DescriptionBuilder.build(title_builder: title_builder,
                                             resource_element: ng_xml.root,
                                             notifier: notifier,
                                             purl: druid ? Cocina::Models::Mapping::Purl.for(druid: druid) : nil)
            props[:title] = [{ value: label }] unless props.key?(:title)
            props
          end

          private

          attr_reader :title_builder, :ng_xml, :notifier, :druid, :label

          def check_altrepgroups
            ng_xml.xpath('//mods:*[@altRepGroup]', mods: DESC_METADATA_NS)
                  .group_by { |node| node['altRepGroup'] }
                  .values
                  .select { |nodes| nodes.size > 1 }
                  .each do |nodes|
                    notifier.warn('Unpaired altRepGroup') if altrepgroup_error?(nodes)
            end
          end

          # rubocop:disable Metrics/CyclomaticComplexity
          def altrepgroup_error?(nodes)
            return true if nodes.map(&:name).uniq.size != 1

            # For subjects, script/lang may be in child so looking in both locations.
            scripts = nodes.map do |node|
              node['script'].presence || node.elements.first&.attribute('script')&.presence
            end.uniq
            # Every node has a different script.
            return false if scripts.size == nodes.size

            langs = nodes.map do |node|
              node['lang'].presence || node.elements.first&.attribute('lang')&.presence
            end.uniq
            # Every node has a different lang.
            return false if langs.size == nodes.size

            # No scripts or langs
            return false if scripts.compact.empty? && langs.compact.empty?

            # altRepGroups can have the same script, e.g. Latn for English and French
            return false if scripts.size == 1

            true
          end
          # rubocop:enable Metrics/CyclomaticComplexity

          def check_version
            match = /MODS version (\d\.\d)/.match(ng_xml.root.at('//mods:recordInfo/mods:recordOrigin',
                                                                 mods: DESC_METADATA_NS)&.content)

            return unless match

            notifier.warn('MODS version mismatch') if match[1] != ng_xml.root['version']
          end
        end
      end
    end
  end
end
