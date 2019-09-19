# frozen_string_literal: true

require 'json'

module Cocina
  module Models
    # A digital repository object.  See https://github.com/sul-dlss-labs/taco/blob/master/maps/DRO.json
    class DRO < Dry::Struct
      # Subschema for access concerns
      class Access < Dry::Struct
        attribute :embargoReleaseDate, Types::Params::DateTime.meta(omittable: true)
      end
      class Administrative < Dry::Struct
      end
      class Identification < Dry::Struct
      end
      class Structural < Dry::Struct
      end

      attribute :externalIdentifier, Types::Strict::String
      attribute :type, Types::Strict::String
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer
      attribute(:access, Access.default { Access.new })
      attribute(:administrative, Administrative.default { Administrative.new })
      attribute(:identification, Identification.default { Identification.new })
      attribute(:structural, Structural.default { Structural.new })

      def self.from_dynamic(dyn)
        params = {
          externalIdentifier: dyn['externalIdentifier'],
          type: dyn['type'],
          label: dyn['label'],
          version: dyn['version']
        }
        if dyn['access']
          access = {
            embargoReleaseDate: dyn['access']['embargoReleaseDate']
          }
          params[:access] = access
        end

        DRO.new(params)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
