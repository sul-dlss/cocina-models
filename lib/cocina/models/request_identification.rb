# frozen_string_literal: true

module Cocina
  module Models
    # Same as a Identification, but requires a sourceId and doesn't permit a DOI.
    class RequestIdentification < Struct
      # A barcode
      attribute? :barcode, Types::Nominal::Any
      attribute :catalogLinks, Types::Strict::Array.of(CatalogLink).default([].freeze)
      # Unique identifier in some other system. This is because a large proportion of what is deposited in SDR, historically and currently, are representations of objects that are also represented in other systems. For example, digitized paper and A/V collections have physical manifestations, and those physical objects are managed in systems that have their own identifiers. Similarly, books have barcodes, archival materials have collection numbers and physical locations, etc. The sourceId allows determining if an item has been deposited before and where to look for the original item if you're looking at its SDR representation. The format is: "namespace:identifier"

      # example: sul:PC0170_s3_Fiesta_Bowl_2012-01-02_210609_2026
      attribute :sourceId, Types::Strict::String
    end
  end
end
