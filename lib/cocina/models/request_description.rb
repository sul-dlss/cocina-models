# frozen_string_literal: true

module Cocina
  module Models
    class RequestDescription < Struct
      attribute :title, Types::Strict::Array.of(Title).default([].freeze)
      attribute :contributor, Types::Strict::Array.of(Contributor).default([].freeze)
      attribute :event, Types::Strict::Array.of(Event).default([].freeze)
      attribute :form, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :geographic, Types::Strict::Array.of(DescriptiveGeographicMetadata).default([].freeze)
      attribute :language, Types::Strict::Array.of(Language).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :subject, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :access, DescriptiveAccessMetadata.optional.meta(omittable: true)
      attribute :relatedResource, Types::Strict::Array.of(RelatedResource).default([].freeze)
      attribute :marcEncodedData, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :adminMetadata, DescriptiveAdminMetadata.optional.meta(omittable: true)
      # URL or other pointer to the location of the resource description.
      attribute :valueAt, Types::Strict::String.meta(omittable: true)

      def self.new(attributes = default_attributes, safe = false, validate = true, &block)
        Validator.validate(self, attributes.with_indifferent_access) if validate && name
        super(attributes, safe, &block)
      end
    end
  end
end
