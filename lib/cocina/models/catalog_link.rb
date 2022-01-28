# frozen_string_literal: true

module Cocina
  module Models
    class CatalogLink < Struct
      # Catalog that is the source of the linked record.
      # example: symphony
      attribute :catalog, Types::Strict::String
      # Record identifier that is unique within the context of the linked record's catalog.
      # example: 11403803
      attribute :catalog_record_id, Types::Strict::String
    end
  end
end
