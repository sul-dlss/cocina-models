# frozen_string_literal: true

module Cocina
  module Models
    class Language < Struct
      attribute :applies_to, Types::Strict::Array.of(DescriptiveBasicValue).default([].freeze)
      # Code value of the descriptive element.
      attribute? :code, Types::Strict::String
      # The preferred display label to use for the descriptive element in access systems.
      attribute? :display_label, Types::Strict::String
      attribute? :encoding, Standard.optional
      attribute :grouped_value, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :parallel_value, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # present for mapping to additional schemas in the future and for consistency but not otherwise used
      attribute? :qualifier, Types::Strict::String
      attribute? :script, DescriptiveValue.optional
      attribute? :source, Source.optional
      # Status of the language relative to other parallel language elements (e.g. the primary language)
      attribute? :status, Types::Strict::String.enum('primary')
      attribute? :standard, Standard.optional
      attribute :structured_value, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # URI value of the descriptive element.
      attribute? :uri, Types::Strict::String
      # Value of the descriptive element.
      attribute? :value, Types::Strict::String
      # URL or other pointer to the location of the language information.
      attribute? :value_at, Types::Strict::String
      attribute? :value_language, DescriptiveValueLanguage.optional

      alias appliesTo applies_to
      deprecation_deprecate :appliesTo
      alias displayLabel display_label
      deprecation_deprecate :displayLabel
      alias groupedValue grouped_value
      deprecation_deprecate :groupedValue
      alias parallelValue parallel_value
      deprecation_deprecate :parallelValue
      alias structuredValue structured_value
      deprecation_deprecate :structuredValue
      alias valueAt value_at
      deprecation_deprecate :valueAt
      alias valueLanguage value_language
      deprecation_deprecate :valueLanguage
    end
  end
end
