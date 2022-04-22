# frozen_string_literal: true

module Cocina
  module Normalizers
    module Mods
      # Normalizes a Fedora MODS document for title elements.
      class TitleNormalizer
        # @param [Nokogiri::Document] mods_ng_xml MODS to be normalized
        # @param [String] label
        # @return [Nokogiri::Document] normalized MODS
        def self.normalize(mods_ng_xml:, label:)
          new(mods_ng_xml: mods_ng_xml, label: label).normalize
        end

        def self.normalize_missing_title(mods_ng_xml:, label:)
          new(mods_ng_xml: mods_ng_xml, label: label).normalize_missing_title
        end

        def initialize(mods_ng_xml:, label:)
          @ng_xml = mods_ng_xml.dup
          @ng_xml.encoding = 'UTF-8'
          @label = label
        end

        def normalize
          normalize_hydrus_title
          clean_empty_titles
          normalize_title_type
          normalize_title_trailing
          normalize_title_as_label
          ng_xml
        end

        def normalize_missing_title
          normalize_title_as_label
          ng_xml
        end

        private

        attr_reader :ng_xml, :label

        def normalize_hydrus_title
          titles = ng_xml.root.xpath('mods:titleInfo/mods:title[string-length() > 0]', mods: ModsNormalizer::MODS_NS)
          return if titles.present? || label != 'Hydrus'

          add_title('Hydrus')
        end

        def clean_empty_titles
          ng_xml.root.xpath('//mods:title[not(text())]', mods: ModsNormalizer::MODS_NS).each(&:remove)
          ng_xml.root.xpath('//mods:subTitle[not(text())]', mods: ModsNormalizer::MODS_NS).each(&:remove)
          ng_xml.root.xpath('//mods:titleInfo[not(mods:*) and not(@xlink:href)]',
                            mods: ModsNormalizer::MODS_NS, xlink: ModsNormalizer::XLINK_NS).each(&:remove)
        end

        def normalize_title_type
          ng_xml.root.xpath('//mods:title[@type]', mods: ModsNormalizer::MODS_NS).each do |title_node|
            title_node.delete('type')
          end
        end

        def normalize_title_trailing
          ng_xml.root.xpath('//mods:titleInfo[not(@type="abbreviated")]/mods:title', mods: ModsNormalizer::MODS_NS).each do |title_node|
            title_node.content = title_node.content.delete_suffix(',')
          end
        end

        def normalize_title_as_label
          return if ng_xml.root.xpath('mods:titleInfo/mods:title',
                                      mods: ModsNormalizer::MODS_NS).present? || ng_xml.root.xpath('mods:titleInfo[@xlink:href]', mods: ModsNormalizer::MODS_NS,
                                                                                                                                  xlink: ModsNormalizer::XLINK_NS).present?

          add_title(label)
        end

        def add_title(content)
          new_title_info = Nokogiri::XML::Node.new('titleInfo', Nokogiri::XML(nil))
          new_title = Nokogiri::XML::Node.new('title', Nokogiri::XML(nil))
          new_title.content = content
          new_title_info << new_title
          ng_xml.root << new_title_info
        end
      end
    end
  end
end
