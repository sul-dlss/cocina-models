# frozen_string_literal: true

module Cocina
  module Models
    class RequestFileSet < Struct
      include Checkable

      TYPES = ['http://cocina.sul.stanford.edu/models/fileset.jsonld'].freeze

      attribute :type, Types::Strict::String.enum(*RequestFileSet::TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer
      attribute :access, Access.optional.meta(omittable: true)
      attribute(:identification, FileSetIdentification.default { FileSetIdentification.new })
      attribute(:structural, RequestFileSetStructural.default { RequestFileSetStructural.new })
    end
  end
end
