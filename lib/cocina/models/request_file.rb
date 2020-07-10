# frozen_string_literal: true

module Cocina
  module Models
    class RequestFile < Struct
      include Checkable

      TYPES = [
        'http://cocina.sul.stanford.edu/models/file.jsonld'
      ].freeze

      attribute :type, Types::Strict::String.enum(*RequestFile::TYPES)
      attribute :label, Types::Strict::String
      attribute :filename, Types::Strict::String
      attribute :size, Types::Strict::Integer.meta(omittable: true)
      attribute :version, Types::Strict::Integer
      attribute :hasMimeType, Types::Strict::String.meta(omittable: true)
      attribute :externalIdentifier, Types::Strict::String.meta(omittable: true)
      attribute :use, Types::Strict::String.meta(omittable: true)
      attribute :hasMessageDigests, Types::Strict::Array.of(MessageDigest).default([].freeze)
      attribute(:access, Access.default { Access.new })
      attribute(:administrative, FileAdministrative.default { FileAdministrative.new })
      attribute :presentation, Presentation.optional.meta(omittable: true)
    end
  end
end
