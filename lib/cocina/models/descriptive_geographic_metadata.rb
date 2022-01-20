# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveGeographicMetadata < Struct
      attribute :form, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :subject, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
    end
  end
end
