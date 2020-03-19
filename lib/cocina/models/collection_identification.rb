# frozen_string_literal: true

module Cocina
  module Models
    class CollectionIdentification < Struct
      attribute :catalogLinks, Types::Strict::Array.of(CatalogLink).meta(omittable: true)
    end
  end
end
