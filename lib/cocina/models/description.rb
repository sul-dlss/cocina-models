# frozen_string_literal: true

module Cocina
  module Models
    class Description < Struct
      attribute :title, Types::Strict::Array.of(Title).default([])
      attribute :contributor, Types::Strict::Array.of(Contributor).default([])
      attribute :event, Types::Strict::Array.of(Event).default([])
      attribute :form, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :geographic, Types::Strict::Array.of(DescriptiveGeographicMetadata).default([])
      attribute :language, Types::Strict::Array.of(Language).default([])
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :subject, Types::Strict::Array.of(DescriptiveValue).default([])
      # Stanford persistent URL associated with the related resource. Note this is http, not https.
      attribute :purl, Types::Strict::String.meta(omittable: true)
      attribute :access, DescriptiveAccessMetadata.optional.meta(omittable: true)
      attribute :relatedResource, Types::Strict::Array.of(RelatedResource).default([])
      attribute :marcEncodedData, Types::Strict::Array.of(DescriptiveValue).default([])
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
