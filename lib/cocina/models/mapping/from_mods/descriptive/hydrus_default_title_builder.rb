# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMods
        class Descriptive
          # Maps titles
          class HydrusDefaultTitleBuilder
            # @param [Nokogiri::XML::Element] resource_element mods or relatedItem element
            # @param [Cocina::Models::Mapping::ErrorNotifier] notifier
            # @return [Hash] a hash that can be mapped to a cocina model
            def self.build(resource_element:, notifier:, require_title: nil)
              titles = resource_element.xpath('mods:titleInfo/mods:title[string-length() > 0]',
                                              mods: DESC_METADATA_NS)

              if titles.empty?
                return [{ value: 'Hydrus' }] if resource_element.name != 'relatedItem'

                return []
              end

              Title.build(resource_element: resource_element, notifier: notifier)
            end
          end
        end
      end
    end
  end
end
