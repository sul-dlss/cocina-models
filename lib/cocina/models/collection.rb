# frozen_string_literal: true

require 'json'

module Cocina
  module Models
    # A digital repository collection.  See http://sul-dlss.github.io/cocina-models/maps/Collection.json
    class Collection < Dry::Struct
      TYPES = %w[http://cocina.sul.stanford.edu/models/collection.jsonld
                 http://cocina.sul.stanford.edu/models/curated-collection.jsonld
                 http://cocina.sul.stanford.edu/models/user-collection.jsonld
                 http://cocina.sul.stanford.edu/models/exhibit.jsonld
                 http://cocina.sul.stanford.edu/models/series.jsonld].freeze

      # Subschema for access concerns
      class Access < Dry::Struct
        def self.from_dynamic(_dyn)
          params = {}
          Access.new(params)
        end
      end

      # Subschema for administrative concerns
      class Administrative < Dry::Struct
        def self.from_dynamic(_dyn)
          params = {}
          Administrative.new(params)
        end
      end

      class Identification < Dry::Struct
      end

      class Structural < Dry::Struct
      end

      attribute :externalIdentifier, Types::Strict::String
      attribute :type, Types::String.enum(*TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Coercible::Integer
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

        # params[:access] = Access.from_dynamic(dyn['access']) if dyn['access']
        # params[:administrative] = Administrative.from_dynamic(dyn['administrative']) if dyn['administrative']

        Collection.new(params)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
