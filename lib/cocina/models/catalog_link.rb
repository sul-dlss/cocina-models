# frozen_string_literal: true

module Cocina
  module Models
    # Metadata for a catalog link
    class CatalogLink < Dry::Struct
      attribute :catalog, Types::Strict::String
      attribute :catalogRecordId, Types::Strict::String

      def self.from_dynamic(dyn)
        params = {
          catalog: dyn['catalog'],
          catalogRecordId: dyn['catalogRecordId']
        }
        CatalogLink.new(params)
      end
    end
  end
end
