# frozen_string_literal: true

module Cocina
  module Models
    class Description < Struct
      include Validatable

      # Titles of the resource.
      attribute :title, Types::Strict::Array.of(Title).default([].freeze)
      # Agents contributing in some way to the creation and history of the resource.
      attribute :contributor, Types::Strict::Array.of(Contributor).default([].freeze)
      # Events in the history of the resource.
      attribute :event, Types::Strict::Array.of(Event).default([].freeze)
      # Characteristics of the resource's physical, digital, and intellectual form and genre,
      # and of its process of creation.
      attribute :form, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Geographic description for items with coordinates or bounding boxes.
      attribute :geographic, Types::Strict::Array.of(DescriptiveGeographicMetadata).default([].freeze)
      # Languages, scripts, symbolic systems, and notations used in all or part of a resource.
      attribute :language, Types::Strict::Array.of(Language).default([].freeze)
      # Additional information relevant to a resource.
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Identifiers and URIs associated with the resource.
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Terms associated with the intellectual content of the resource.
      attribute :subject, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Information about how to access digital and physical versions of the object.
      attribute? :access, DescriptiveAccessMetadata.optional
      # Other resources associated with the described resource.
      attribute :relatedResource, Types::Strict::Array.of(RelatedResource).default([].freeze)
      # Data about the resource represented in MARC fixed fields and codes.
      attribute :marcEncodedData, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Information about this resource description.
      attribute? :adminMetadata, DescriptiveAdminMetadata.optional
      # URL or other pointer to the location of the resource description.
      attribute? :valueAt, Types::Strict::String
      # Stanford persistent URL associated with the related resource.
      attribute :purl, Purl
    end
  end
end
