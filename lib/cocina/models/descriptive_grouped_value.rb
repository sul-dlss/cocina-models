# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveGroupedValue < Struct
      attribute :groupedValue, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
    end
  end
end
