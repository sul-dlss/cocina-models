# frozen_string_literal: true

module Cocina
  module Models
    # A request to create a file.
    # This is same as a File, but without externalIdentifier (as that wouldn't have been created yet)
    # See http://sul-dlss.github.io/cocina-models/maps/File.json
    class RequestFile < Struct
      attribute(:access, File::Access.optional.default { File::Access.new })
      attribute(:administrative, File::Administrative.default { File::Administrative.new })
      attribute :type, Types::String.enum(*File::TYPES)
      attribute :label, Types::Strict::String
      attribute :filename, Types::String.optional.default(nil)
      attribute :use, Types::String.enum('transcription').optional.meta(omittable: true)
      attribute :size, Types::Coercible::Integer.optional.default(nil)
      attribute :hasMessageDigests, Types::Strict::Array.of(File::Fixity).default([].freeze)
      attribute :hasMimeType, Types::String.optional.meta(omittable: true)
      attribute :presentation, File::Presentation.optional.meta(omittable: true)
      attribute :version, Types::Coercible::Integer
      attribute :identification, File::Identification.optional.meta(omittable: true)
      attribute :structural, File::Structural.optional.meta(omittable: true)

      def self.from_dynamic(dyn)
        new(dyn)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
