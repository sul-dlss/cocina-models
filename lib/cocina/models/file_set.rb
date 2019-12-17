# frozen_string_literal: true

require 'json'

module Cocina
  module Models
    # Metadata for a File Set.  See http://sul-dlss.github.io/cocina-models/maps/Fileset.json
    class FileSet < Dry::Struct
      TYPES = [
        Vocab.fileset
      ].freeze

      class Identification < Dry::Struct
      end

      # Structural sub-schema for the FileSet
      class Structural < Dry::Struct
        attribute :contains, Types::Strict::Array.of(Types::Coercible::String).meta(omittable: true)

        def self.from_dynamic(dyn)
          params = {}
          params[:contains] = dyn['contains'] if dyn['contains']
          Structural.new(params)
        end
      end

      attribute :externalIdentifier, Types::Strict::String
      attribute :type, Types::String.enum(*TYPES)
      attribute :label, Types::Strict::String
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
        params[:structural] = Structural.from_dynamic(dyn['structural']) if dyn['structural']

        FileSet.new(params)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
