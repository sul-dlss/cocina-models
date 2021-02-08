# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveGroupedValue < Struct
      attribute :groupedValue, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
    end
  end
end
