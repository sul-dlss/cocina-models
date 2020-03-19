# frozen_string_literal: true

module Cocina
  module Models
    class FileSet < Struct
      include Checkable

      TYPES = ['http://cocina.sul.stanford.edu/models/fileset.jsonld'].freeze

      attribute :type, Types::Strict::String.enum(*FileSet::TYPES)
      attribute :externalIdentifier, Types::Strict::String
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer
      attribute(:access, Access.default { Access.new })
      attribute(:identification, FileSetIdentification.default { FileSetIdentification.new })
      attribute(:structural, FileSetStructural.default { FileSetStructural.new })
    end
  end
end
