# frozen_string_literal: true

module Cocina
  module Models
    class Title < Struct
      attribute :structuredValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :parallelValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :groupedValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # String or integer value of the descriptive element.
      attribute? :value, Types::Nominal::Any
      # Type of value provided by the descriptive element. See https://github.com/sul-dlss/cocina-models/blob/main/docs/description_types.md
      # for valid types.
      attribute? :type, Types::Strict::String
      # Status of the descriptive element value relative to other instances of the element.
      attribute? :status, Types::Strict::String
      # Code value of the descriptive element.
      attribute? :code, Types::Strict::String
      # URI value of the descriptive element.
      attribute? :uri, Types::Strict::String
      # Property model for indicating the encoding, standard, or syntax to which a value
      # conforms (e.g. RDA).
      attribute? :standard, Standard.optional
      # Property model for indicating the encoding, standard, or syntax to which a value
      # conforms (e.g. RDA).
      attribute? :encoding, Standard.optional
      # Identifiers and URIs associated with the descriptive element.
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Property model for indicating the vocabulary, authority, or other origin for a term,
      # code, or identifier.
      attribute? :source, Source.optional
      # The preferred display label to use for the descriptive element in access systems.
      attribute? :displayLabel, Types::Strict::String
      # A term providing information about the circumstances of the statement (e.g., approximate
      # dates).
      attribute? :qualifier, Types::Strict::String
      # Other information related to the descriptive element.
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Language of the descriptive element value
      attribute? :valueLanguage, DescriptiveValueLanguage.optional
      # URL or other pointer to the location of the value of the descriptive element.
      attribute? :valueAt, Types::Strict::String
      attribute :appliesTo, Types::Strict::Array.of(DescriptiveBasicValue).default([].freeze)
    end
  end
end
