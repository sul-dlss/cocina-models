# frozen_string_literal: true

require 'json'

module Cocina
  module Models
    # A digital repository collection.  See https://github.com/sul-dlss-labs/taco/blob/master/maps/Collection.json
    class Collection < Dry::Struct
      COLLECTION_TYPES = %w[http://sdr.sul.stanford.edu/models/sdr3-collection.jsonld
                            http://sdr.sul.stanford.edu/models/sdr3-curated-collection.jsonld
                            http://sdr.sul.stanford.edu/models/sdr3-user-collection.jsonld
                            http://sdr.sul.stanford.edu/models/sdr3-exhibit.jsonld
                            http://sdr.sul.stanford.edu/models/sdr3-series.jsonld].freeze

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
      attribute :type, Types::String.enum(*COLLECTION_TYPES)
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
