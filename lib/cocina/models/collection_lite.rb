# frozen_string_literal: true

module Cocina
  module Models
    # A group of Digital Repository Objects that indicate some type of conceptual grouping within the domain that is worth reusing across the system.
    class CollectionLite < Struct
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
      attribute :type, Types::Strict::String.enum(*CollectionLite::TYPES)
      # example: druid:bc123df4567
      attribute :externalIdentifier, Druid
      # Primary processing label (can be same as title) for a Collection.
      attribute :label, Types::Strict::String
      # Version for the Collection within SDR.
      attribute :version, Types::Strict::Integer
      attribute? :access, CollectionAccess.optional
      attribute? :administrative, Administrative.optional
      attribute? :description, Description.optional
      attribute? :identification, CollectionIdentification.optional
    end
  end
end
