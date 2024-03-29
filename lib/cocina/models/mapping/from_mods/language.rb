# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMods
        # Maps languages
        class Language
          # @param [Nokogiri::XML::Element] resource_element mods or relatedItem element
          # @param [Cocina::Models::Mapping::FromMods::DescriptionBuilder] description_builder
          # @param [String] purl
          # @return [Hash] a hash that can be mapped to a cocina model
          def self.build(resource_element:, description_builder:, purl: nil)
            new(resource_element: resource_element, description_builder: description_builder).build
          end

          def initialize(resource_element:, description_builder:)
            @resource_element = resource_element
            @notifier = description_builder.notifier
          end

          def build
            languages = resource_element.xpath('mods:language', mods: Description::DESC_METADATA_NS).map do |lang_node|
              Cocina::Models::Mapping::FromMods::LanguageTerm.build(language_element: lang_node, notifier: notifier)
            end
            Primary.adjust(languages, 'language', notifier)
          end

          private

          attr_reader :resource_element, :notifier
        end
      end
    end
  end
end
