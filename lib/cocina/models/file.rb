# frozen_string_literal: true

require 'json'

module Cocina
  module Models
    # Metadata for a file.  See http://sul-dlss.github.io/cocina-models/maps/File.json
    class File < Dry::Struct
      include Checkable

      TYPES = [
        Vocab.file
      ].freeze

      class Identification < Dry::Struct
      end

      class Structural < Dry::Struct
      end

      # Represents a digest value for a file
      class Fixity < Dry::Struct
        attribute :type, Types::String.enum('md5', 'sha1')
        attribute :digest, Types::Strict::String

        def self.from_dynamic(dyn)
          params = {
            type: dyn['type'],
            digest: dyn['digest']
          }

          Fixity.new(params)
        end
      end

      # Represents some technical aspect of the file
      class Presentation < Dry::Struct
        attribute :height, Types::Coercible::Integer.optional.default(nil)
        attribute :width, Types::Coercible::Integer.optional.default(nil)

        def self.from_dynamic(dyn)
          params = {
            height: dyn['height'],
            width: dyn['width']
          }

          Presentation.new(params)
        end
      end

      attribute :externalIdentifier, Types::Strict::String
      attribute :type, Types::String.enum(*TYPES)
      attribute :label, Types::Strict::String
      attribute :filename, Types::String.optional.default(nil)
      attribute :use, Types::String.enum('original', 'preservation', 'access').optional.default(nil)
      attribute :size, Types::Coercible::Integer.optional.default(nil)
      attribute :hasMessageDigests, Types::Strict::Array.of(Fixity).default([].freeze)
      attribute(:presentation, Presentation.optional.default { Presentation.new })
      attribute :version, Types::Coercible::Integer
      attribute(:identification, Identification.default { Identification.new })
      attribute(:structural, Structural.default { Structural.new })

      def self.from_dynamic(dyn)
        params = {
          externalIdentifier: dyn['externalIdentifier'],
          type: dyn['type'],
          label: dyn['label'],
          version: dyn['version'],
          size: dyn['size'],
          use: dyn['use']
        }
        params[:presentation] = Presentation.from_dynamic(dyn['presentation']) if dyn['presentation']
        if dyn['hasMessageDigests']
          params[:hasMessageDigests] = dyn['hasMessageDigests'].map { |p| Fixity.from_dynamic(p) }
        end
        File.new(params)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
