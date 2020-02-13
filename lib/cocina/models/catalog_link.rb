# frozen_string_literal: true

module Cocina
  module Models
    # Metadata for a catalog link
    class CatalogLink < Struct
      attribute :catalog, Types::Strict::String
      attribute :catalogRecordId, Types::Strict::String
    end
  end
end
