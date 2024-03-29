# frozen_string_literal: true

module Cocina
  module Models
    # Collection with addition object metadata.
    class CollectionWithMetadata < Struct
      include Validatable

      include Checkable

      TYPES = ['https://cocina.sul.stanford.edu/models/collection',
               'https://cocina.sul.stanford.edu/models/curated-collection',
               'https://cocina.sul.stanford.edu/models/user-collection',
               'https://cocina.sul.stanford.edu/models/exhibit',
               'https://cocina.sul.stanford.edu/models/series'].freeze

      # The version of Cocina with which this object conforms.
      # example: 1.2.3
      attribute :cocinaVersion, CocinaVersion.default(VERSION)
      # The content type of the Collection. Selected from an established set of values.
      attribute :type, Types::Strict::String.enum(*CollectionWithMetadata::TYPES)
      # example: druid:bc123df4567
      attribute :externalIdentifier, Druid
      # Primary processing label (can be same as title) for a Collection.
      attribute :label, Types::Strict::String
      # Version for the Collection within SDR.
      attribute :version, Types::Strict::Integer
      attribute(:access, CollectionAccess.default { CollectionAccess.new })
      attribute(:administrative, Administrative.default { Administrative.new })
      attribute(:description, Description.default { Description.new })
      attribute(:identification, CollectionIdentification.default { CollectionIdentification.new })
      # When the object was created.
      attribute? :created, Types::Params::DateTime
      # When the object was modified.
      attribute? :modified, Types::Params::DateTime
      # Key for optimistic locking. The contents of the key is not specified.
      attribute :lock, Types::Strict::String
    end
  end
end
