# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveBasicValue < Struct
      attribute :structuredValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :parallelValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :groupedValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # String or integer value of the descriptive element.
      attribute :value, Types::Nominal::Any.meta(omittable: true)
      # Type of value provided by the descriptive element.
      attribute :type, Types::Strict::String.meta(omittable: true)
      # Status of the descriptive element value relative to other instances of the element.
      attribute :status, Types::Strict::String.meta(omittable: true)
      # Code value of the descriptive element.
      attribute :code, Types::Strict::String.meta(omittable: true)
      # URI value of the descriptive element.
      attribute :uri, Types::Strict::String.meta(omittable: true)
      attribute :standard, Standard.optional.meta(omittable: true)
      attribute :encoding, Standard.optional.meta(omittable: true)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :source, Source.optional.meta(omittable: true)
      # The preferred display label to use for the descriptive element in access systems.
      attribute :displayLabel, Types::Strict::String.meta(omittable: true)
      # A term providing information about the circumstances of the statement (e.g., approximate dates).
      attribute :qualifier, Types::Strict::String.meta(omittable: true)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :valueLanguage, DescriptiveValueLanguage.optional.meta(omittable: true)
      # URL or other pointer to the location of the value of the descriptive element.
      attribute :valueAt, Types::Strict::String.meta(omittable: true)
    end
  end
end
