# frozen_string_literal: true

module Cocina
  module Models
    class RequestCollection < Struct
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
      attribute :type, Types::Strict::String.enum(*RequestCollection::TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer.default(1).enum(1)
      attribute(:access, CollectionAccess.default { CollectionAccess.new })
      attribute(:administrative, RequestAdministrative.default { RequestAdministrative.new })
      attribute :description, RequestDescription.optional.meta(omittable: true)
      attribute :identification, CollectionIdentification.optional.meta(omittable: true)
    end
  end
end
