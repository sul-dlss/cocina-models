# frozen_string_literal: true

module Cocina
  module Models
    # A digital repository object.  See http://sul-dlss.github.io/cocina-models/maps/DRO.json
    class DRO < Struct
      include Checkable

      TYPES = [
        Vocab.object,
        Vocab.three_dimensional,
        Vocab.agreement,
        Vocab.book,
        Vocab.document,
        Vocab.geo,
        Vocab.image,
        Vocab.page,
        Vocab.photograph,
        Vocab.manuscript,
        Vocab.map,
        Vocab.media,
        Vocab.track,
        Vocab.webarchive_binary,
        Vocab.webarchive_seed
      ].freeze

      # Subschema for access concerns
      class Access < Struct
        # Subschema for embargo concerns
        class Embargo < Struct
          attribute :releaseDate, Types::Params::DateTime
          attribute :access, Types::String.default('dark')
                                          .enum('world', 'stanford', 'location-based', 'citation-only', 'dark')
        end

        attribute :embargo, Embargo.optional.meta(omittable: true)
      end

      # Subschema for administrative concerns
      class Administrative < Struct
        attribute :releaseTags, Types::Strict::Array.of(ReleaseTag).meta(omittable: true).default([].freeze)
        # Allowing hasAdminPolicy to be omittable for now (until rolled out to consumers),
        # but I think it's actually required for every DRO
        attribute :hasAdminPolicy, Types::Coercible::String.optional.default(nil)
      end

      # Identification sub-schema for the DRO
      class Identification < Struct
        attribute :sourceId, Types::Strict::String.meta(omittable: true)
        attribute :catalogLinks, Types::Strict::Array.of(CatalogLink).meta(omittable: true)
      end

      # Structural sub-schema for the DRO
      class Structural < Struct
        attribute :contains, Types::Strict::Array.of(FileSet).meta(omittable: true)
        attribute :isMemberOf, Types::Strict::String.meta(omittable: true)
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
        DRO.new(dyn)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end

      def image?
        type == Vocab.image
      end
    end
  end
end
