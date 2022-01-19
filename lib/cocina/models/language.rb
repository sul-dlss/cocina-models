# frozen_string_literal: true

module Cocina
  module Models
    class Language < Struct
      attribute :appliesTo, Types::Strict::Array.of(DescriptiveBasicValue).default([])
      # Code value of the descriptive element.
      attribute :code, Types::Strict::String.meta(omittable: true)
      # The preferred display label to use for the descriptive element in access systems.
      attribute :displayLabel, Types::Strict::String.meta(omittable: true)
      attribute :encoding, Standard.optional.meta(omittable: true)
      attribute :groupedValue, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :parallelValue, Types::Strict::Array.of(DescriptiveValue).default([])
      # present for mapping to additional schemas in the future and for consistency but not otherwise used
      attribute :qualifier, Types::Strict::String.meta(omittable: true)
      attribute :script, DescriptiveValue.optional.meta(omittable: true)
      attribute :source, Source.optional.meta(omittable: true)
      # Status of the language relative to other parallel language elements (e.g. the primary language)
      attribute :status, Types::Strict::String.enum('primary').meta(omittable: true)
      attribute :standard, Standard.optional.meta(omittable: true)
      attribute :structuredValue, Types::Strict::Array.of(DescriptiveValue).default([])
      # URI value of the descriptive element.
      attribute :uri, Types::Strict::String.meta(omittable: true)
      # Value of the descriptive element.
      attribute :value, Types::Strict::String.meta(omittable: true)
      # URL or other pointer to the location of the language information.
      attribute :valueAt, Types::Strict::String.meta(omittable: true)
      attribute :valueLanguage, DescriptiveValueLanguage.optional.meta(omittable: true)
    end
  end
end
