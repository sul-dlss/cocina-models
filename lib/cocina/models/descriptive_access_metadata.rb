# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveAccessMetadata < Struct
      attribute :url, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :physical_location, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :digital_location, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :access_contact, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :digital_repository, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
    end
  end
end
