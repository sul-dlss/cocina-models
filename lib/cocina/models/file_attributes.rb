# frozen_string_literal: true

module Cocina
  module Models
    # attributes common to both File and RequestFile
    # See http://sul-dlss.github.io/cocina-models/maps/File.json
    module FileAttributes
      def self.included(obj)
        obj.attribute(:access, File::Access.optional.default { File::Access.new })
        obj.attribute(:administrative, File::Administrative.default { File::Administrative.new })
        obj.attribute :label, Types::Strict::String
        obj.attribute :filename, Types::String.optional.default(nil)
        obj.attribute :identification, File::Identification.optional.meta(omittable: true)
        obj.attribute :hasMessageDigests, Types::Strict::Array.of(File::Fixity).default([].freeze)
        obj.attribute :hasMimeType, Types::String.optional.meta(omittable: true)
        obj.attribute :presentation, File::Presentation.optional.meta(omittable: true)
        obj.attribute :size, Types::Coercible::Integer.optional.default(nil)
        obj.attribute :structural, File::Structural.optional.meta(omittable: true)
        obj.attribute :type, Types::String.enum(*File::TYPES)
        obj.attribute :use, Types::String.enum('transcription').optional.meta(omittable: true)
        obj.attribute :version, Types::Coercible::Integer
      end
    end
  end
end
