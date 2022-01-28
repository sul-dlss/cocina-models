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
      attribute? :has_mime_type, Types::Strict::String
      attribute? :external_identifier, Types::Strict::String
      attribute? :use, Types::Strict::String
      attribute :has_message_digests, Types::Strict::Array.of(MessageDigest).default([].freeze)
      attribute(:access, FileAccess.default { FileAccess.new })
      attribute(:administrative, FileAdministrative.default { FileAdministrative.new })
      attribute? :presentation, Presentation.optional

      alias hasMimeType has_mime_type
      deprecation_deprecate :hasMimeType
      alias externalIdentifier external_identifier
      deprecation_deprecate :externalIdentifier
      alias hasMessageDigests has_message_digests
      deprecation_deprecate :hasMessageDigests
    end
  end
end
