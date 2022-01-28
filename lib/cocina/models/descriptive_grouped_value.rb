# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveGroupedValue < Struct
      attribute :grouped_value, Types::Strict::Array.of(DescriptiveValue).default([].freeze)

      alias groupedValue grouped_value
      deprecation_deprecate :groupedValue
    end
  end
end
