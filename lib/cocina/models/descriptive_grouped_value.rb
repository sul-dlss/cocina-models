# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveGroupedValue < Struct
      attribute :grouped_value, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
    end
  end
end
