# frozen_string_literal: true

module Cocina
  module Models
    # Value model for a set of descriptive elements grouped together in an unstructured way.
    class DescriptiveGroupedValue < Struct
      attribute :groupedValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
    end
  end
end
