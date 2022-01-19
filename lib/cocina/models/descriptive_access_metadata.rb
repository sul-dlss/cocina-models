# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveAccessMetadata < Struct
      attribute :url, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :physicalLocation, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :digitalLocation, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :accessContact, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :digitalRepository, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([])
    end
  end
end
