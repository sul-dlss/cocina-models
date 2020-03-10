# frozen_string_literal: true

module Cocina
  module Models
    # attributes common to both Collection and RequestCollection
    # See http://sul-dlss.github.io/cocina-models/maps/Collection.json
    module CollectionAttributes
      def self.included(obj)
        obj.attribute(:access, Collection::Access.default { Collection::Access.new })
        obj.attribute(:administrative, Collection::Administrative.default { Collection::Administrative.new })
        # TODO: Allowing description to be omittable for now (until rolled out to consumers),
        # but I think it's actually required for every Collection
        obj.attribute :description, Description.optional.meta(omittable: true)
        obj.attribute(:identification, Collection::Identification.default { Collection::Identification.new })
        obj.attribute :label, Types::Strict::String
        obj.attribute(:structural, Collection::Structural.default { Collection::Structural.new })
        obj.attribute :type, Types::String.enum(*Collection::TYPES)
        obj.attribute :version, Types::Strict::Integer
      end
    end
  end
end
