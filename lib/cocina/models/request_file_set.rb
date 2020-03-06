# frozen_string_literal: true

module Cocina
  module Models
    # A request to create a FileSet object.
    # This is the same as a FileSet, but without externalIdentifier (as that wouldn't have been created yet)
    # See http://sul-dlss.github.io/cocina-models/maps/FileSet.json
    class RequestFileSet < Struct
      include FileSetAttributes

      # Structural sub-schema that contains RequestFile (unlike the FileSet which contains File)
      class Structural < Struct
        attribute :contains, Types::Strict::Array.of(RequestFile).meta(omittable: true)
      end

      attribute(:structural, Structural.default { Structural.new })

      def self.from_dynamic(dyn)
        RequestFileSet.new(dyn)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
