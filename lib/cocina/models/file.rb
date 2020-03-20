# frozen_string_literal: true

module Cocina
  module Models
    class File < Struct
      include Checkable

      TYPES = ['http://cocina.sul.stanford.edu/models/file.jsonld'].freeze

      # The content type of the File.
      attribute :type, Types::Strict::String.enum(*File::TYPES)
      # Identifier for the resource within the SDR architecture but outside of the repository. UUID. Constant across resource versions. What clients will use calling the repository.
      attribute :externalIdentifier, Types::Strict::String
      # Primary processing label (can be same as title) for a File.
      attribute :label, Types::Strict::String
      # Filename for a file. Can be same as label.
      attribute :filename, Types::Strict::String.meta(omittable: true)
      # Size of the File (binary) in bytes.
      attribute :size, Types::Strict::Integer.meta(omittable: true)
      # Version for the File within SDR.
      attribute :version, Types::Strict::Integer
      # MIME Type of the File.
      attribute :hasMimeType, Types::Strict::String.meta(omittable: true)
      # Use for the File.
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
