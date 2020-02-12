# frozen_string_literal: true

module Cocina
  module Models
    # Metadata for a file.  See http://sul-dlss.github.io/cocina-models/maps/File.json
    class File < Dry::Struct
      include Checkable

      TYPES = [
        Vocab.file
      ].freeze

      # Represents access controls on the file
      class Access < Dry::Struct
        attribute :access, Types::String.default('dark')
                                        .enum('world', 'stanford', 'location-based', 'citation-only', 'dark')

        def self.from_dynamic(dyn)
          return unless dyn

          params = {}
          params[:access] = dyn['access'] if dyn['access']

          Access.new(params)
        end
      end

      # Represents the administration of the file
      class Administrative < Dry::Struct
        attribute :sdrPreserve, Types::Params::Bool.optional.default(false)
        attribute :shelve, Types::Params::Bool.optional.default(false)

        def self.from_dynamic(dyn)
          return unless dyn

          params = {
            sdrPreserve: dyn['sdrPreserve'],
            shelve: dyn['shelve']
          }
          Administrative.new(params)
        end
      end

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
          return unless dyn

          params = {
            height: dyn['height'],
            width: dyn['width']
          }

          Presentation.new(params)
        end
      end

      attribute(:access, Access.optional.default { Access.new })
      attribute(:administrative, Administrative.default { Administrative.new })
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
        params[:administrative] = Administrative.from_dynamic(dyn['administrative'])
        params[:presentation] = Presentation.from_dynamic(dyn['presentation'])
        params[:access] = Access.from_dynamic(dyn['access'])
        params[:hasMessageDigests] = Array(dyn['hasMessageDigests']).map { |p| Fixity.from_dynamic(p) }
        File.new(params)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
