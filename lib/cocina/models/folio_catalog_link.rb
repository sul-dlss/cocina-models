# frozen_string_literal: true

module Cocina
  module Models
    # A linkage between an object and a Folio catalog record
    class FolioCatalogLink < BaseModel
      attr_accessor :catalog, :refresh, :catalogRecordId, :partLabel, :sortKey
    end
  end
end
