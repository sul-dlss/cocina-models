# frozen_string_literal: true

module Cocina
  module Models
    # A digital repository object.
    # See http://sul-dlss.github.io/cocina-models/maps/DRO.json
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

        attribute :access, Types::String.default('dark')
                                        .enum('world', 'stanford', 'location-based', 'citation-only', 'dark')
        attribute :copyright, Types::Strict::String.meta(omittable: true)
        attribute :embargo, Embargo.optional.meta(omittable: true)
        attribute :useAndReproductionStatement, Types::Strict::String.meta(omittable: true)
      end

      # Subschema for administrative concerns
      class Administrative < Struct
        # TODO: Allowing hasAdminPolicy to be omittable for now (until rolled out to consumers),
        # but I think it's actually required for every DRO
        attribute :hasAdminPolicy, Types::Strict::String.optional.default(nil)
        attribute :releaseTags, Types::Strict::Array.of(ReleaseTag).meta(omittable: true).default([].freeze)
      end

      # Identification sub-schema for the DRO
      class Identification < Struct
        attribute :sourceId, Types::Strict::String.meta(omittable: true)
        attribute :catalogLinks, Types::Strict::Array.of(CatalogLink).meta(omittable: true)
      end

      # Geographic sub-schema for the DRO
      class Geographic < Struct
        attribute :iso19139, Types::Strict::String
      end

      # Structural sub-schema for the DRO (uses FileSet, unlike RequestDRO which uses RequestFileSet)
      class Structural < Struct
        attribute :contains, Types::Strict::Array.of(FileSet).meta(omittable: true)
        attribute :hasAgreement, Types::Strict::String.meta(omittable: true)
        attribute :isMemberOf, Types::Strict::String.meta(omittable: true)
        attribute :hasMemberOrders, Types::Strict::Array.of(Sequence).meta(omittable: true)
      end

      include DroAttributes
      attribute :externalIdentifier, Types::Strict::String
      attribute(:structural, Structural.default { Structural.new })

      def image?
        type == Vocab.image
      end
    end
  end
end
