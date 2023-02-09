# frozen_string_literal: true

module Cocina
  module Models
    # A linkage between an object and a Symphony catalog record
    class SymphonyCatalogLink < Struct
      # Catalog that is the source of the linked record.
      # example: symphony
      attribute :catalog, Types::Strict::String.enum('symphony', 'previous symphony')
      # Only one of the catkeys should be designated for refreshing. This means that this key is the one used to pull metadata from the catalog if there is more than one key present.
      attribute :refresh, Types::Strict::Bool.default(false)
      # Record identifier that is unique within the context of the linked record's catalog.
      # example: 11403803
      attribute :catalogRecordId, Types::Strict::String.constrained(format: /^\d+$/)
    end
  end
end
