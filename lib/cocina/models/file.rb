# frozen_string_literal: true

module Cocina
  module Models
    class File < Struct
      include Checkable

      TYPES = ['http://cocina.sul.stanford.edu/models/file.jsonld'].freeze

      attribute :type, Types::Strict::String.enum(*File::TYPES)
      attribute :externalIdentifier, Types::Strict::String
      attribute :label, Types::Strict::String
      attribute :filename, Types::Strict::String.meta(omittable: true)
      attribute :size, Types::Strict::Integer.meta(omittable: true)
      attribute :version, Types::Strict::Integer
      attribute :hasMimeType, Types::Strict::String.meta(omittable: true)
      attribute :use, Types::Strict::String.meta(omittable: true)
      attribute :hasMessageDigests, Types::Strict::Array.of(MessageDigest).default([].freeze)
      attribute(:access, Access.default { Access.new })
      attribute(:administrative, FileAdministrative.default { FileAdministrative.new })
      attribute :identification, FileIdentification.optional.meta(omittable: true)
      attribute(:structural, FileStructural.default { FileStructural.new })
      attribute :presentation, Presentation.optional.meta(omittable: true)
    end
  end
end
