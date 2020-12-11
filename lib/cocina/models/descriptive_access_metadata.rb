# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveAccessMetadata < Struct
      attribute :url, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :physicalLocation, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :digitalLocation, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :accessContact, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :digitalRepository, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
    end
  end
end
