# frozen_string_literal: true

module Cocina
  module Models
    # Value model for multiple representations of the same information (e.g. in different languages).
    class DescriptiveParallelValue < Struct
      attribute :parallelValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
    end
  end
end
