# frozen_string_literal: true

module Cocina
  module Models
    # Metadata for a file.  See http://sul-dlss.github.io/cocina-models/maps/File.json
    class File < Struct
      include Checkable

      TYPES = [
        Vocab.file
      ].freeze

      # Represents access controls on the file
      class Access < Struct
        attribute :access, Types::String.default('dark')
                                        .enum('world', 'stanford', 'location-based', 'citation-only', 'dark')
      end

      # Represents the administration of the file
      class Administrative < Struct
        attribute :sdrPreserve, Types::Params::Bool.optional.default(false)
        attribute :shelve, Types::Params::Bool.optional.default(false)
      end

      class Identification < Struct
      end

      class Structural < Struct
      end

      # Represents a digest value for a file
      class Fixity < Struct
        attribute :type, Types::String.enum('md5', 'sha1')
        attribute :digest, Types::Strict::String
      end

      # Represents some technical aspect of the file
      class Presentation < Struct
        attribute :height, Types::Coercible::Integer.optional.default(nil)
        attribute :width, Types::Coercible::Integer.optional.default(nil)
      end

      attribute(:access, Access.optional.default { Access.new })
      attribute(:administrative, Administrative.default { Administrative.new })
      attribute :externalIdentifier, Types::Strict::String
      attribute :type, Types::String.enum(*TYPES)
      attribute :label, Types::Strict::String
      attribute :filename, Types::String.optional.default(nil)
      attribute :use, Types::String.enum('original', 'preservation', 'access').optional.meta(omittable: true)
      attribute :size, Types::Coercible::Integer.optional.default(nil)
      attribute :hasMessageDigests, Types::Strict::Array.of(Fixity).default([].freeze)
      attribute :hasMimeType, Types::String.optional.meta(omittable: true)
      attribute(:presentation, Presentation.optional.meta(omittable: true))
      attribute :version, Types::Coercible::Integer
      attribute(:identification, Identification.optional.meta(omittable: true))
      attribute(:structural, Structural.optional.meta(omittable: true))

      def self.from_dynamic(dyn)
        File.new(dyn)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
