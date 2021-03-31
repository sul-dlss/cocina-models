# frozen_string_literal: true

module Cocina
  module Models
    class Description < Struct
      attribute :title, Types::Strict::Array.of(Title).default([].freeze)
      attribute :contributor, Types::Strict::Array.of(Contributor).meta(omittable: true)
      attribute :event, Types::Strict::Array.of(Event).meta(omittable: true)
      attribute :form, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :geographic, Types::Strict::Array.of(DescriptiveGeographicMetadata).meta(omittable: true)
      attribute :language, Types::Strict::Array.of(Language).meta(omittable: true)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :subject, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      # Stanford persistent URL associated with the resource.
      attribute :purl, Types::Strict::String.optional.meta(omittable: true)
      attribute :access, DescriptiveAccessMetadata.optional.meta(omittable: true)
      attribute :relatedResource, Types::Strict::Array.of(RelatedResource).meta(omittable: true)
      attribute :marcEncodedData, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :adminMetadata, DescriptiveAdminMetadata.optional.meta(omittable: true)
      # URL or other pointer to the location of the resource description.
      attribute :valueAt, Types::Strict::String.optional.meta(omittable: true)

      def self.new(attributes = default_attributes, safe = false, validate = true, &block)
        Validator.validate(self, attributes.with_indifferent_access) if validate && name
        super(attributes, safe, &block)
      end
    end
  end
end
