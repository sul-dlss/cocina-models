# frozen_string_literal: true

module Cocina
  module Models
    class Title < Struct
      attribute :structured_value, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :parallel_value, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :grouped_value, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # String or integer value of the descriptive element.
      attribute? :value, Types::Nominal::Any
      # Type of value provided by the descriptive element. See https://sul-dlss.github.io/cocina-models/description_types.html for valid types.
      attribute? :type, Types::Strict::String
      # Status of the descriptive element value relative to other instances of the element.
      attribute? :status, Types::Strict::String
      # Code value of the descriptive element.
      attribute? :code, Types::Strict::String
      # URI value of the descriptive element.
      attribute? :uri, Types::Strict::String
      attribute? :standard, Standard.optional
      attribute? :encoding, Standard.optional
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute? :source, Source.optional
      # The preferred display label to use for the descriptive element in access systems.
      attribute? :display_label, Types::Strict::String
      # A term providing information about the circumstances of the statement (e.g., approximate dates).
      attribute? :qualifier, Types::Strict::String
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute? :value_language, DescriptiveValueLanguage.optional
      # URL or other pointer to the location of the value of the descriptive element.
      attribute? :value_at, Types::Strict::String
      attribute :applies_to, Types::Strict::Array.of(DescriptiveBasicValue).default([].freeze)

      alias structuredValue structured_value
      deprecation_deprecate :structuredValue
      alias parallelValue parallel_value
      deprecation_deprecate :parallelValue
      alias groupedValue grouped_value
      deprecation_deprecate :groupedValue
      alias displayLabel display_label
      deprecation_deprecate :displayLabel
      alias valueLanguage value_language
      deprecation_deprecate :valueLanguage
      alias valueAt value_at
      deprecation_deprecate :valueAt
      alias appliesTo applies_to
      deprecation_deprecate :appliesTo
    end
  end
end
