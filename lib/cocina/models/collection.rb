# frozen_string_literal: true

module Cocina
  module Models
    # A digital repository collection.  See http://sul-dlss.github.io/cocina-models/maps/Collection.json
    class Collection < Struct
      include Checkable

      TYPES = [
        Vocab.collection,
        Vocab.curated_collection,
        Vocab.user_collection,
        Vocab.exhibit,
        Vocab.series
      ].freeze

      # Subschema for access concerns
      class Access < Struct
        attribute :access, Types::String.default('dark')
                                        .enum('world', 'stanford', 'location-based', 'citation-only', 'dark')
      end

      # Subschema for administrative concerns
      class Administrative < Struct
        attribute :releaseTags, Types::Strict::Array.of(ReleaseTag).default([].freeze)
        # Allowing hasAdminPolicy to be omittable for now (until rolled out to consumers),
        # but I think it's actually required for every DRO
        attribute :hasAdminPolicy, Types::Coercible::String.optional.default(nil)
      end

      # Identification sub-schema for the Collection
      class Identification < Struct
        attribute :catalogLinks, Types::Strict::Array.of(CatalogLink).meta(omittable: true)
      end

      class Structural < Struct
      end

      attribute :externalIdentifier, Types::Strict::String
      attribute :type, Types::String.enum(*TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Coercible::Integer
      attribute(:access, Access.default { Access.new })
      attribute(:administrative, Administrative.default { Administrative.new })
      # Allowing description to be omittable for now (until rolled out to consumers),
      # but I think it's actually required for every DRO
      attribute :description, Description.optional.default(nil)
      attribute(:identification, Identification.default { Identification.new })
      attribute(:structural, Structural.default { Structural.new })

      def self.from_dynamic(dyn)
        Collection.new(dyn)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
