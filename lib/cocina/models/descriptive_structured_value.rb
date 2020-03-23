# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveStructuredValue < Struct
      attribute :structuredValue, Types::Strict::Array.of(DescriptiveBasicValue).meta(omittable: true)
    end
  end
end
