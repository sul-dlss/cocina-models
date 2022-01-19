# frozen_string_literal: true

module Cocina
  module Models
    class AppliesTo < Struct
      attribute :appliesTo, Types::Strict::Array.of(DescriptiveBasicValue).default([])
    end
  end
end
