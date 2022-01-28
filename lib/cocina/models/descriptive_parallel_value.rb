# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveParallelValue < Struct
      attribute :parallel_value, Types::Strict::Array.of(DescriptiveValue).default([].freeze)

      alias parallelValue parallel_value
      deprecation_deprecate :parallelValue
    end
  end
end
