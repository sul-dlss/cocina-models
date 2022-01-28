# frozen_string_literal: true

module Cocina
  module Models
    class AppliesTo < Struct
      attribute :applies_to, Types::Strict::Array.of(DescriptiveBasicValue).default([].freeze)
    end
  end
end
