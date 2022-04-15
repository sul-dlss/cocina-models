# frozen_string_literal: true

module Cocina
  module Models
    class RequestFile < Struct
      include Checkable

      TYPES = ['https://cocina.sul.stanford.edu/models/file'].freeze

      attribute :type, Types::Strict::String.enum(*RequestFile::TYPES)
      attribute :label, Types::Strict::String
      attribute :filename, Types::Strict::String
      attribute? :size, Types::Strict::Integer
      attribute :version, Types::Strict::Integer
      attribute? :hasMimeType, Types::Strict::String
      attribute? :externalIdentifier, Types::Strict::String
      attribute? :use, Types::Strict::String
      attribute :hasMessageDigests, Types::Strict::Array.of(MessageDigest).default([].freeze)
      attribute(:access, FileAccess.default { FileAccess.new })
      attribute(:administrative, FileAdministrative.default { FileAdministrative.new })
      attribute? :presentation, Presentation.optional
    end
  end
end
