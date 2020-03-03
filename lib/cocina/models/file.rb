# frozen_string_literal: true

module Cocina
  module Models
    # Metadata for a file.
    # See http://sul-dlss.github.io/cocina-models/maps/File.json
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

      # Represents a digest (checksum) value for a file
      class Fixity < Struct
        attribute :type, Types::String.enum('md5', 'sha1')
        attribute :digest, Types::Strict::String
      end

      class Identification < Struct
      end

      # Represents some technical aspect of the file
      class Presentation < Struct
        attribute :height, Types::Coercible::Integer.optional.default(nil)
        attribute :width, Types::Coercible::Integer.optional.default(nil)
      end

      class Structural < Struct
      end

      include FileAttributes
      attribute :externalIdentifier, Types::Strict::String

      def self.from_dynamic(dyn)
        File.new(dyn)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
