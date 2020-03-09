# frozen_string_literal: true

module Cocina
  module Models
    # a request to create a File object.
    # This is the same as a File, but without externalIdentifier (as that wouldn't have been created yet)
    # See http://sul-dlss.github.io/cocina-models/maps/File.json
    class RequestFile < Struct
      include FileAttributes
    end
  end
end
