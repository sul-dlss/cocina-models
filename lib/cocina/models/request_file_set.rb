# frozen_string_literal: true

module Cocina
  module Models
    class RequestFileSet < Struct
      include Checkable

      TYPES = ['http://cocina.sul.stanford.edu/models/fileset.jsonld'].freeze

      attribute :type, Types::Strict::String.enum(*RequestFileSet::TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer
      attribute(:structural, RequestFileSetStructural.default { RequestFileSetStructural.new })
    end
  end
end
