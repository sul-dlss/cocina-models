# frozen_string_literal: true

module Cocina
  module Models
    # Property model for indicating the parts, aspects, or versions of the resource to
    # which a descriptive element is applicable.
    class AppliesTo < Struct
      attribute :appliesTo, Types::Strict::Array.of(DescriptiveBasicValue).default([].freeze)
    end
  end
end
