# frozen_string_literal: true

module Cocina
  module Models
    # Information about how to access digital and physical versions of the object.
    class DescriptiveAccessMetadata < Struct
      attribute :url, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :physicalLocation, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :digitalLocation, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :accessContact, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :digitalRepository, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
    end
  end
end
