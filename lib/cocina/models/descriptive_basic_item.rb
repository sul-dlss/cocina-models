# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveBasicItem < Struct
      attribute? :structuredValue, Types::Strict::Array.of(DescriptiveValue)#.default([].freeze)
      attribute? :parallelValue, Types::Strict::Array.of(DescriptiveValue)#.default([].freeze)
      attribute? :groupedValue, Types::Strict::Array.of(DescriptiveValue)#.default([].freeze)
      # String or integer value of the descriptive element.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute? :value, Types::Nominal::Any.optional
    end
  end
end
