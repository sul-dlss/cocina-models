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
      attribute :title, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :contributor, Types::Strict::Array.of(Contributor).meta(omittable: true)
      attribute :event, Types::Strict::Array.of(Event).meta(omittable: true)
      attribute :form, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :language, Types::Strict::Array.of(Language).meta(omittable: true)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      attribute :standard, Standard.optional.meta(omittable: true)
      attribute :subject, Types::Strict::Array.of(DescriptiveValue).meta(omittable: true)
      # Stanford persistent URL associated with the related resource.
      attribute :purl, Types::Strict::String.meta(omittable: true)
      attribute :access, DescriptiveAccessMetadata.optional.meta(omittable: true)
      attribute :relatedResource, Types::Strict::Array.of(RelatedResource).meta(omittable: true)
      attribute :adminMetadata, DescriptiveAdminMetadata.optional.meta(omittable: true)
      # The version of the related resource.
      attribute :version, Types::Strict::String.meta(omittable: true)
      # The order of the related resource in a series of related resources.
      attribute :order, Types::Strict::Integer.meta(omittable: true)
    end
  end
end
