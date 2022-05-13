# frozen_string_literal: true

module Cocina
  module Models
    # Value model for descriptive elements structured as typed, ordered values.
    class DescriptiveStructuredValue < Struct
      attribute :structuredValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
    end
  end
end
