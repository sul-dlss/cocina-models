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

      alias physicalLocation physical_location
      deprecation_deprecate :physicalLocation
      alias digitalLocation digital_location
      deprecation_deprecate :digitalLocation
      alias accessContact access_contact
      deprecation_deprecate :accessContact
      alias digitalRepository digital_repository
      deprecation_deprecate :digitalRepository
    end
  end
end
