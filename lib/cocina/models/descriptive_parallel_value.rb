# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveParallelValue < Struct
      attribute :parallelValue, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
    end
  end
end
