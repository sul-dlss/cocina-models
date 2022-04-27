# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMods
        # Maps lang and script attributes
        class LanguageScript
          # @param [Nokogiri::XML::Element] element that may have lang or script attributes
          # @param [Cocina::Models::Mapping::FromMods::DescriptionBuilder] description_builder
          # @return [Hash] a hash that can be mapped to a cocina model for a valueLanguage
          def self.build(node:)
            return nil unless node['lang'].present? || node['script'].present?

            {}.tap do |value_language|
              if node['lang'].present?
                value_language[:code] = node['lang']
                value_language[:source] = { code: 'iso639-2b' }
              end
              if node['script'].present?
                value_language[:valueScript] =
                  { code: node['script'], source: { code: 'iso15924' } }
              end
            end
          end
        end
      end
    end
  end
end
