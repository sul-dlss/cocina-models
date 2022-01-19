# frozen_string_literal: true

module Cocina
  module Models
    class RelatedResource < Struct
      # The relationship of the related resource to the described resource.
      attribute :type, Types::Strict::String.meta(omittable: true)
      # Status of the related resource relative to other related resources.
      attribute :status, Types::Strict::String.meta(omittable: true)
      # The preferred display label to use for the related resource in access systems.
      attribute :displayLabel, Types::Strict::String.meta(omittable: true)
      attribute :title, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :contributor, Types::Strict::Array.of(Contributor).default([])
      attribute :event, Types::Strict::Array.of(Event).default([])
      attribute :form, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :language, Types::Strict::Array.of(Language).default([])
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([])
      attribute :standard, Standard.optional.meta(omittable: true)
      attribute :subject, Types::Strict::Array.of(DescriptiveValue).default([])
      # Stanford persistent URL associated with the related resource. Note this is http, not https.
      attribute :purl, Types::Strict::String.meta(omittable: true)
      attribute :access, DescriptiveAccessMetadata.optional.meta(omittable: true)
      attribute :relatedResource, Types::Strict::Array.of(RelatedResource).default([])
      attribute :adminMetadata, DescriptiveAdminMetadata.optional.meta(omittable: true)
      # The version of the related resource.
      attribute :version, Types::Strict::String.meta(omittable: true)
      # URL or other pointer to the location of the related resource information.
      attribute :valueAt, Types::Strict::String.meta(omittable: true)
    end
  end
end
