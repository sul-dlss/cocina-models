# frozen_string_literal: true

module Cocina
  module Models
    class AppliesTo < Struct
      attribute :applies_to, Types::Strict::Array.of(DescriptiveBasicValue).default([].freeze)

      alias appliesTo applies_to
      deprecation_deprecate :appliesTo
    end
  end
end
