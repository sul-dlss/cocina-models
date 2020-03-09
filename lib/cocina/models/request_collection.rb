# frozen_string_literal: true

module Cocina
  module Models
    # A request to create a digital repository collection.
    # This is the same as a Collection, but without externalIdentifier (as that wouldn't have been created yet).
    # See http://sul-dlss.github.io/cocina-models/maps/Collection.json
    class RequestCollection < Struct
      include CollectionAttributes
    end
  end
end
