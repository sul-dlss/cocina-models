# frozen_string_literal: true

module Cocina
  module Models
    # Other resource associated with the described resource.
    class RelatedResource < Struct
      # The relationship of the related resource to the described resource.
      attribute? :type, Types::Strict::String
      # The DataCite relationType describing the relationship from the related resource to
      # the described resource. See https://datacite-metadata-schema.readthedocs.io/en/4.6/appendices/appendix-1/relationType
      attribute? :dataCiteRelationType, Types::Strict::String.enum('IsCitedBy', 'Cites', 'IsSupplementTo', 'IsSupplementedBy', 'IsContinuedBy', 'Continues', 'Describes', 'IsDescribedBy', 'HasMetadata', 'IsMetadataFor', 'HasVersion', 'IsVersionOf', 'IsNewVersionOf', 'IsPreviousVersionOf', 'IsPartOf', 'HasPart', 'IsPublishedIn', 'IsReferencedBy', 'References', 'IsDocumentedBy', 'Documents', 'IsCompiledBy', 'Compiles', 'IsVariantFormOf', 'IsOriginalFormOf', 'IsIdenticalTo', 'IsReviewedBy', 'Reviews', 'IsDerivedFrom', 'IsSourceOf', 'IsRequiredBy', 'Requires', 'Obsoletes', 'IsObsoletedBy', 'IsCollectedBy', 'Collects', 'IsTranslationOf', 'HasTranslation')
      # Status of the related resource relative to other related resources.
      attribute? :status, Types::Strict::String
      # The preferred display label to use for the related resource in access systems.
      attribute? :displayLabel, Types::Strict::String
      # Titles of the related resource.
      attribute :title, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Agents contributing in some way to the creation and history of the related resource.
      attribute :contributor, Types::Strict::Array.of(Contributor).default([].freeze)
      # Events in the history of the related resource.
      attribute :event, Types::Strict::Array.of(Event).default([].freeze)
      # Characteristics of the related resource's physical, digital, and intellectual form
      # and genre, and of its process of creation.
      attribute :form, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Languages, scripts, symbolic systems, and notations used in all or part of a related
      # resource.
      attribute :language, Types::Strict::Array.of(Language).default([].freeze)
      # Additional information relevant to a related resource.
      attribute :note, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Identifiers and URIs associated with the related resource.
      attribute :identifier, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Property model for indicating the encoding, standard, or syntax to which a value
      # conforms (e.g. RDA).
      attribute? :standard, Standard.optional
      # Terms associated with the intellectual content of the related resource.
      attribute :subject, Types::Strict::Array.of(DescriptiveValue).default([].freeze)
      # Stanford persistent URL associated with the related resource.
      attribute? :purl, Purl.optional
      # Information about how to access digital and physical versions of the object.
      attribute? :access, DescriptiveAccessMetadata.optional
      # Other resources associated with the related resource.
      attribute :relatedResource, Types::Strict::Array.of(RelatedResource).default([].freeze)
      # Information about this resource description.
      attribute? :adminMetadata, DescriptiveAdminMetadata.optional
      # The version of the related resource.
      attribute? :version, Types::Strict::String
      # URL or other pointer to the location of the related resource information.
      attribute? :valueAt, Types::Strict::String
    end
  end
end
