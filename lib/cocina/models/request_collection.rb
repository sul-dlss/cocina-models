# frozen_string_literal: true

module Cocina
  module Models
    # A request to create a digital repository collection.
    # This is the same as Collection, except it doesn't have externalIdentifier.
    # See http://sul-dlss.github.io/cocina-models/maps/Collection.json
    class RequestCollection < Dry::Struct
      attribute :type, Types::String.enum(*Collection::TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Coercible::Integer
      attribute(:access, Collection::Access.default { Collection::Access.new })
      attribute(:administrative, Collection::Administrative.default { Collection::Administrative.new })
      # Allowing description to be omittable for now (until rolled out to consumers),
      # but I think it's actually required for every DRO
      attribute :description, Description.optional.default(nil)
      attribute(:identification, Collection::Identification.default { Collection::Identification.new })
      attribute(:structural, Collection::Structural.default { Collection::Structural.new })

      def self.from_dynamic(dyn)
        CollectionBuilder.build(self, dyn)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
