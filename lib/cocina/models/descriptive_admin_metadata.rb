# frozen_string_literal: true

module Cocina
  module Models
    # Information about this resource description.
    class DescriptiveAdminMetadata < Struct
      # Contributors to this resource description.
      attribute :contributor, Types::Strict::Array.of(Contributor).default([].freeze)
      # Events in the history of this resource description.
      attribute :event, Types::Strict::Array.of(Event).default([].freeze)
      # Languages, scripts, symbolic systems, and notations used in this resource description.
      attribute :language, Types::Strict::Array.of(Language).default([].freeze)
      # Other information related to this resource description.
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Descriptive or content standard(s) to which this resource description conforms.
      attribute :metadataStandard, Types::Strict::Array.of(Standard).default([].freeze)
      # Identifiers associated with this resource description.
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
    end
  end
end
