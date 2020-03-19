# frozen_string_literal: true

module Cocina
  module Models
    class CatalogLink < Struct
      # example: symphony
      attribute :catalog, Types::Strict::String
      # example: 11403803
      attribute :catalogRecordId, Types::Strict::String
    end
  end
end
