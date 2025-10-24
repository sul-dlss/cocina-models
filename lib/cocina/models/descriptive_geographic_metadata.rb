# frozen_string_literal: true

module Cocina
  module Models
    # Value model for mods geographic extension metadata
    class DescriptiveGeographicMetadata < Struct
      attribute :form, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Terms associated with the intellectual content of the related resource.
      attribute :subject, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
    end
  end
end
