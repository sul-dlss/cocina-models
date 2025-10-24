# frozen_string_literal: true

module Cocina
  module Models
    # Information about how to access digital and physical versions of the object.
    class DescriptiveAccessMetadata < Struct
      # URLs where the resource may be accessed in full or part.
      attribute :url, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Location of a physical version of the resource.
      attribute :physicalLocation, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Location of a digital version of the resource, such as a file path for a born digital
      # resource.
      attribute :digitalLocation, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # The library, organization, or person responsible for access to the resource.
      attribute :accessContact, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # The digital repositories that hold the resource.
      attribute :digitalRepository, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Other information related to accessing the resource.
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
    end
  end
end
