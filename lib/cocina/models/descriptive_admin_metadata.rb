# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveAdminMetadata < Struct
      attribute :contributor, Types::Strict::Array.of(Contributor).default([])
      attribute :event, Types::Strict::Array.of(Event).default([])
      attribute :language, Types::Strict::Array.of(Language).default([])
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :metadataStandard, Types::Strict::Array.of(Standard).default([])
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([])
    end
  end
end
