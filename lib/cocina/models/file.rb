# frozen_string_literal: true

module Cocina
  module Models
    class File < Struct
      include Checkable

      TYPES = ['https://cocina.sul.stanford.edu/models/file'].freeze

      # The content type of the File.
      attribute :type, Types::Strict::String.enum(*File::TYPES)
      # Identifier for the resource within the SDR architecture but outside of the repository. UUID. Constant across resource versions. What clients will use calling the repository.
      attribute :externalIdentifier, Types::Strict::String
      # Primary processing label (can be same as title) for a File.
      attribute :label, Types::Strict::String
      # Filename for a file. Can be same as label.
      attribute :filename, Types::Strict::String
      # Size of the File (binary) in bytes.
      attribute? :size, Types::Strict::Integer
      # Version for the File within SDR.
      attribute :version, Types::Strict::Integer
      # MIME Type of the File.
      attribute? :hasMimeType, Types::Strict::String
      # Use for the File.
      attribute? :use, Types::Strict::String
      attribute :hasMessageDigests, Types::Strict::Array.of(MessageDigest).default([].freeze)
      attribute(:access, FileAccess.default { FileAccess.new })
      attribute(:administrative, FileAdministrative.default { FileAdministrative.new })
      attribute? :presentation, Presentation.optional
    end
  end
end
