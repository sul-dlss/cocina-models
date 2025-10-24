# frozen_string_literal: true

module Cocina
  module Models
    # Languages, scripts, symbolic systems, and notations used in all or part of a resource
    # or its descriptive metadata.
    class Language < Struct
      attribute :appliesTo, Types::Strict::Array.of(DescriptiveBasicValue).default([].freeze)
      # Code value of the descriptive element.
      attribute? :code, Types::Strict::String
      # The preferred display label to use for the descriptive element in access systems.
      attribute? :displayLabel, Types::Strict::String
      # Property model for indicating the encoding, standard, or syntax to which a value
      # conforms (e.g. RDA).
      attribute? :encoding, Standard.optional
      # present for mapping to additional schemas in the future and for consistency but not
      # otherwise used
      attribute :groupedValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # present for mapping to additional schemas in the future and for consistency but not
      # otherwise used
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # present for mapping to additional schemas in the future and for consistency but not
      # otherwise used
      attribute :parallelValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # present for mapping to additional schemas in the future and for consistency but not
      # otherwise used
      attribute? :qualifier, Types::Strict::String
      # Default value model for descriptive elements.
      attribute? :script, DescriptiveValue.optional
      # Property model for indicating the vocabulary, authority, or other origin for a term,
      # code, or identifier.
      attribute? :source, Source.optional
      # Status of the language relative to other parallel language elements (e.g. the primary
      # language)
      attribute? :status, Types::Strict::String.enum('primary')
      # Property model for indicating the encoding, standard, or syntax to which a value
      # conforms (e.g. RDA).
      attribute? :standard, Standard.optional
      # present for mapping to additional schemas in the future and for consistency but not
      # otherwise used
      attribute :structuredValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # URI value of the descriptive element.
      attribute? :uri, Types::Strict::String
      # Value of the descriptive element.
      attribute? :value, Types::Strict::String
      # URL or other pointer to the location of the language information.
      attribute? :valueAt, Types::Strict::String
      # Language of the descriptive element value
      attribute? :valueLanguage, DescriptiveValueLanguage.optional
    end
  end
end
