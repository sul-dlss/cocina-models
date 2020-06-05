# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveValue < Struct
      # String value of the descriptive element.
      attribute :value, Types::Strict::String.meta(omittable: true)
      # Type of value provided by the descriptive element.
      attribute :type, Types::Strict::String.meta(omittable: true)
      # Status of the descriptive element relative to other instances of the element.
      attribute :status, Types::Strict::String.meta(omittable: true)
      # Code value of the descriptive element.
      attribute :code, Types::Strict::String.meta(omittable: true)
      # URI value of the descriptive element.
      attribute :uri, Types::Strict::String.meta(omittable: true)
      attribute :standard, Standard.optional.meta(omittable: true)
      attribute :encoding, Standard.optional.meta(omittable: true)
      attribute :source, Source.optional.meta(omittable: true)
      attribute :displayLabel, Types::Strict::String.meta(omittable: true)
      attribute :qualifier, Types::Strict::String.meta(omittable: true)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :structuredValue, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :parallelValue, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :appliesTo, Types::Strict::Array.of(DescriptiveBasicValue).meta(omittable: true)
    end
  end
end
