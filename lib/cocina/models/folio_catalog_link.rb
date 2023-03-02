# frozen_string_literal: true

module Cocina
  module Models
    # A linkage between an object and a Folio catalog record
    class FolioCatalogLink < Struct
      # Catalog that is the source of the linked record.
      # example: folio
      attribute :catalog, Types::Strict::String.enum('folio', 'previous folio')
      # Only one of the Folio instance HRIDs should be designated for refreshing. This means that this HRID is the one used to pull metadata from the catalog if there is more than one HRID present.
      attribute :refresh, Types::Strict::Bool.default(false)
      # Record identifier that is unique within the context of the linked record's catalog.
      attribute :catalogRecordId, MigratedFromSymphonyIdentifier | MigratedFromVoyagerIdentifier | CreatedInFolioIdentifier
    end
  end
end
