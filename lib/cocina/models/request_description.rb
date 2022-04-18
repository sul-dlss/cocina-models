# frozen_string_literal: true

module Cocina
  module Models
    class RequestDescription < Struct
      include Validatable

      attribute :title, Types::Strict::Array.of(Title).default([].freeze)
      attribute :contributor, Types::Strict::Array.of(Contributor).default([].freeze)
      attribute :event, Types::Strict::Array.of(Event).default([].freeze)
      attribute :form, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :geographic, Types::Strict::Array.of(DescriptiveGeographicMetadata).default([].freeze)
      attribute :language, Types::Strict::Array.of(Language).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :subject, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute? :access, DescriptiveAccessMetadata.optional
      attribute :relatedResource, Types::Strict::Array.of(RelatedResource).default([].freeze)
      attribute :marcEncodedData, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute? :adminMetadata, DescriptiveAdminMetadata.optional
      # URL or other pointer to the location of the resource description.
      attribute? :valueAt, Types::Strict::String
    end
  end
end
