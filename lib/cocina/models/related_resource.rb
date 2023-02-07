# frozen_string_literal: true

module Cocina
  module Models
    # Other resource associated with the described resource.
    class RelatedResource < Struct
      # The relationship of the related resource to the described resource.
      attribute? :type, Types::Strict::String
      # Status of the related resource relative to other related resources.
      attribute? :status, Types::Strict::String
      # The preferred display label to use for the related resource in access systems.
      attribute? :displayLabel, Types::Strict::String
      attribute :title, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :contributor, Types::Strict::Array.of(Contributor).default([].freeze)
      attribute :event, Types::Strict::Array.of(Event).default([].freeze)
      attribute :form, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :language, Types::Strict::Array.of(Language).default([].freeze)
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      attribute? :standard, Standard.optional
      attribute :subject, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Stanford persistent URL associated with the related resource.
      attribute? :purl, Types::Strict::String
      attribute? :access, DescriptiveAccessMetadata.optional
      attribute :relatedResource, Types::Strict::Array.of(RelatedResource).default([].freeze)
      attribute? :adminMetadata, DescriptiveAdminMetadata.optional
      # The version of the related resource.
      attribute? :version, Types::Strict::String
      # URL or other pointer to the location of the related resource information.
      attribute? :valueAt, Types::Strict::String
    end
  end
end
