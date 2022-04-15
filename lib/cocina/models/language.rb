# frozen_string_literal: true

module Cocina
  module Models
    class Language < Struct
      attribute :appliesTo, Types::Strict::Array.of(DescriptiveBasicValue).default([].freeze)
      # Code value of the descriptive element.
      attribute? :code, Types::Strict::String
      # The preferred display label to use for the descriptive element in access systems.
      attribute? :displayLabel, Types::Strict::String
      attribute? :encoding, Standard.optional
      attribute :groupedValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :parallelValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # present for mapping to additional schemas in the future and for consistency but not otherwise used
      attribute? :qualifier, Types::Strict::String
      attribute? :script, DescriptiveValue.optional
      attribute? :source, Source.optional
      # Status of the language relative to other parallel language elements (e.g. the primary language)
      attribute? :status, Types::Strict::String.enum('primary')
      attribute? :standard, Standard.optional
      attribute :structuredValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # URI value of the descriptive element.
      attribute? :uri, Types::Strict::String
      # Value of the descriptive element.
      attribute? :value, Types::Strict::String
      # URL or other pointer to the location of the language information.
      attribute? :valueAt, Types::Strict::String
      attribute? :valueLanguage, DescriptiveValueLanguage.optional
    end
  end
end
