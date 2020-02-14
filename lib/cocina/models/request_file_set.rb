# frozen_string_literal: true

module Cocina
  module Models
    # A Request to create a FileSet object.
    # This is same as a FileSet, but without externalIdentifier (as that wouldn't have been created yet)
    # See http://sul-dlss.github.io/cocina-models/maps/FileSet.json
    class RequestFileSet < Struct
      attribute :type, Types::String.enum(*FileSet::TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Coercible::Integer
      attribute(:identification, FileSet::Identification.default { FileSet::Identification.new })
      attribute(:structural, FileSet::Structural.default { FileSet::Structural.new })
    end
  end
end
