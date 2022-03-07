# frozen_string_literal: true

module Cocina
  module Models
    class RequestCollection < Struct
      include Validatable

      include Checkable

      include TitleBuilder

      TYPES = ['https://cocina.sul.stanford.edu/models/collection',
               'https://cocina.sul.stanford.edu/models/curated-collection',
               'https://cocina.sul.stanford.edu/models/user-collection',
               'https://cocina.sul.stanford.edu/models/exhibit',
               'https://cocina.sul.stanford.edu/models/series'].freeze

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
