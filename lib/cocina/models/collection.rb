# frozen_string_literal: true

module Cocina
  module Models
    class Collection < Struct
      include Validatable

      include Checkable

      TYPES = ['http://cocina.sul.stanford.edu/models/collection.jsonld',
               'http://cocina.sul.stanford.edu/models/curated-collection.jsonld',
               'http://cocina.sul.stanford.edu/models/user-collection.jsonld',
               'http://cocina.sul.stanford.edu/models/exhibit.jsonld',
               'http://cocina.sul.stanford.edu/models/series.jsonld'].freeze

      # The version of Cocina with which this object conforms.
      # example: 1.2.3
      attribute :cocinaVersion, Types::Strict::String.default(Cocina::Models::VERSION)
      # The content type of the Collection. Selected from an established set of values.
      attribute :type, Types::Strict::String.enum(*Collection::TYPES)
      # example: druid:bc123df4567
      attribute :externalIdentifier, Types::Strict::String
      # Primary processing label (can be same as title) for a Collection.
      attribute :label, Types::Strict::String
      # Version for the Collection within SDR.
      attribute :version, Types::Strict::Integer
      attribute(:access, CollectionAccess.default { CollectionAccess.new })
      attribute :administrative, Administrative.optional.meta(omittable: true)
      attribute :description, Description.optional.meta(omittable: true)
      attribute :identification, CollectionIdentification.optional.meta(omittable: true)
    end
  end
end
