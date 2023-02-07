# frozen_string_literal: true

module Cocina
  module Models
    # Same as a Collection, but doesn't have an externalIdentifier as one will be created
    class RequestCollection < Struct
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
      attribute :type, Types::Strict::String.enum(*RequestCollection::TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer.default(1).enum(1)
      attribute(:access, CollectionAccess.default { CollectionAccess.new })
      attribute(:administrative, RequestAdministrative.default { RequestAdministrative.new })
      attribute? :description, RequestDescription.optional
      attribute? :identification, CollectionIdentification.optional
    end
  end
end
