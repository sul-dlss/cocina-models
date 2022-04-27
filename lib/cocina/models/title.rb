# frozen_string_literal: true

module Cocina
  module Models
    class Title < Struct
      attribute? :structuredValue, Types::Strict::Array.of(DescriptiveValue)#.default([].freeze)
      attribute? :parallelValue, Types::Strict::Array.of(DescriptiveValue)#.default([].freeze)
      attribute? :groupedValue, Types::Strict::Array.of(DescriptiveValue)#.default([].freeze)
      # String or integer value of the descriptive element.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute? :value, Types::Nominal::Any.optional
      # Type of value provided by the descriptive element. See https://github.com/sul-dlss/cocina-models/blob/main/docs/description_types.md for valid types.
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
      attribute? :displayLabel, Types::Strict::String
      # A term providing information about the circumstances of the statement (e.g., approximate dates).
      attribute? :qualifier, Types::Strict::String
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute? :valueLanguage, DescriptiveValueLanguage.optional
      # URL or other pointer to the location of the value of the descriptive element.
      attribute? :valueAt, Types::Strict::String
      attribute :appliesTo, Types::Strict::Array.of(DescriptiveBasicValue).default([].freeze)
    end
  end
end
