# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveStructuredValue < Struct
      attribute :structured_value, Types::Strict::Array.of(DescriptiveValue).default([].freeze)

      alias structuredValue structured_value
      deprecation_deprecate :structuredValue
    end
  end
end
