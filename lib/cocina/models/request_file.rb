# frozen_string_literal: true

module Cocina
  module Models
    class RequestFile < Struct
      include Checkable

      TYPES = ['https://cocina.sul.stanford.edu/models/file'].freeze

      attribute :type, Types::Strict::String.enum(*RequestFile::TYPES)
      attribute :label, Types::Strict::String
      attribute :filename, Types::Strict::String
      attribute :size, Types::Strict::Integer.meta(omittable: true)
      attribute :version, Types::Strict::Integer
      attribute :has_mime_type, Types::Strict::String.meta(omittable: true)
      attribute :external_identifier, Types::Strict::String.meta(omittable: true)
      attribute :use, Types::Strict::String.meta(omittable: true)
      attribute :has_message_digests, Types::Strict::Array.of(MessageDigest).default([].freeze)
      attribute(:access, FileAccess.default { FileAccess.new })
      attribute(:administrative, FileAdministrative.default { FileAdministrative.new })
      attribute :presentation, Presentation.optional.meta(omittable: true)
    end
  end
end
