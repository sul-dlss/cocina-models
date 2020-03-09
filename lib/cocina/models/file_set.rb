# frozen_string_literal: true

module Cocina
  module Models
    # Metadata for a file set.
    # See http://sul-dlss.github.io/cocina-models/maps/Fileset.json
    class FileSet < Struct
      include Checkable

      TYPES = [
        Vocab.fileset
      ].freeze

      class Identification < Struct
      end

      # Structural sub-schema that contains File (unlike the one in RequestFileSet which contains RequestFile)
      class Structural < Struct
        attribute :contains, Types::Strict::Array.of(Cocina::Models::File).meta(omittable: true)
      end

      include FileSetAttributes
      attribute :externalIdentifier, Types::Strict::String
      attribute(:structural, Structural.default { Structural.new })
    end
  end
end
