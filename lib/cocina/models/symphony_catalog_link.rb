# frozen_string_literal: true

module Cocina
  module Models
    # A linkage between an object and a Symphony catalog record
    class SymphonyCatalogLink < BaseModel
      attr_accessor :catalog, :refresh, :catalogRecordId
    end
  end
end
