# frozen_string_literal: true

module Cocina
  module Models
    # Value model for mods geographic extension metadata
    class DescriptiveGeographicMetadata < Struct
      attribute :form, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :subject, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
    end
  end
end
