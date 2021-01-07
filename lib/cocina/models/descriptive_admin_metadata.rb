# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveAdminMetadata < Struct
      attribute :contributor, Types::Strict::Array.of(Contributor).meta(omittable: true)
      attribute :event, Types::Strict::Array.of(Event).meta(omittable: true)
      attribute :language, Types::Strict::Array.of(Language).meta(omittable: true)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :metadataStandard, Types::Strict::Array.of(Standard).meta(omittable: true)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
    end
  end
end
