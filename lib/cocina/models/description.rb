# frozen_string_literal: true

module Cocina
  module Models
    class Description < Struct
      attribute :title, Types::Strict::Array.of(DescriptiveValueRequired).default([].freeze)
      attribute :contributor, Types::Strict::Array.of(Contributor).meta(omittable: true)
      attribute :event, Types::Strict::Array.of(Event).meta(omittable: true)
      attribute :form, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :language, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      # Stanford persistent URL associated with the resource.
      attribute :purl, Types::Strict::String.meta(omittable: true)
      attribute :url, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :marcEncodedData, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :adminMetadata, DescriptiveAdminMetadata.optional.meta(omittable: true)

      def self.new(attributes = default_attributes, safe = false, validate = true, &block)
        Validator.validate(self, attributes.with_indifferent_access) if validate && name
        super(attributes, safe, &block)
      end
    end
  end
end
