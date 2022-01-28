# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveAdminMetadata < Struct
      attribute :contributor, Types::Strict::Array.of(Contributor).default([].freeze)
      attribute :event, Types::Strict::Array.of(Event).default([].freeze)
      attribute :language, Types::Strict::Array.of(Language).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :metadata_standard, Types::Strict::Array.of(Standard).default([].freeze)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)

      alias metadataStandard metadata_standard
      deprecation_deprecate :metadataStandard
    end
  end
end
