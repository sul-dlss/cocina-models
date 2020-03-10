# frozen_string_literal: true

module Cocina
  module Models
    # attributes common to both FileSet and RequestFileSet
    # See http://sul-dlss.github.io/cocina-models/maps/Fileset.json
    module FileSetAttributes
      def self.included(obj)
        obj.attribute(:identification, FileSet::Identification.default { FileSet::Identification.new })
        obj.attribute :label, Types::Strict::String
        obj.attribute :type, Types::String.enum(*FileSet::TYPES)
        obj.attribute :version, Types::Strict::Integer
      end
    end
  end
end
