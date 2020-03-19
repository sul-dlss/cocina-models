# frozen_string_literal: true

module Cocina
  module Models
    class RequestCollection < Struct
      include Checkable

      TYPES = ['http://cocina.sul.stanford.edu/models/collection.jsonld',
               'http://cocina.sul.stanford.edu/models/curated-collection.jsonld',
               'http://cocina.sul.stanford.edu/models/user-collection.jsonld',
               'http://cocina.sul.stanford.edu/models/exhibit.jsonld',
               'http://cocina.sul.stanford.edu/models/series.jsonld'].freeze

      # example: item
      attribute :type, Types::Strict::String.enum(*RequestCollection::TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer
      attribute(:access, Access.default { Access.new })
      attribute(:administrative, Administrative.default { Administrative.new })
      attribute :description, Description.optional.meta(omittable: true)
      attribute(:identification, CollectionIdentification.default { CollectionIdentification.new })
      attribute(:structural, CollectionStructural.default { CollectionStructural.new })
    end
  end
end
