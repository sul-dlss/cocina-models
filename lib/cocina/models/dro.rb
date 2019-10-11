# frozen_string_literal: true

require 'json'

module Cocina
  module Models
    # A digital repository object.  See https://github.com/sul-dlss-labs/taco/blob/master/maps/DRO.json
    class DRO < Dry::Struct
      TYPES = %w[
        http://sdr.sul.stanford.edu/models/sdr3-object.jsonld
        http://sdr.sul.stanford.edu/models/sdr3-3d.jsonld
        http://sdr.sul.stanford.edu/models/sdr3-agreement.jsonl
        http://sdr.sul.stanford.edu/models/sdr3-book.jsonld
        http://sdr.sul.stanford.edu/models/sdr3-document.jsonld
        http://sdr.sul.stanford.edu/models/sdr3-geo.jsonld
        http://sdr.sul.stanford.edu/models/sdr3-image.jsonld
        http://sdr.sul.stanford.edu/models/sdr3-page.jsonld
        http://sdr.sul.stanford.edu/models/sdr3-photograph.jsonld
        http://sdr.sul.stanford.edu/models/sdr3-manuscript.jsonld
        http://sdr.sul.stanford.edu/models/sdr3-map.jsonld
        http://sdr.sul.stanford.edu/models/sdr3-media.jsonld
        http://sdr.sul.stanford.edu/models/sdr3-track.jsonld
        http://sdr.sul.stanford.edu/models/sdr3-webarchive-binary.jsonld
        http://sdr.sul.stanford.edu/models/sdr3-webarchive-seed.jsonld
      ].freeze
      # Subschema for release tags
      class ReleaseTag < Dry::Struct
        attribute :to, Types::Strict::String
        attribute :what, Types::Strict::String.enum('self', 'collection')
        # we use 'when' other places, but that's reserved word, so 'date' it is!
        attribute :date, Types::Params::DateTime
        attribute :who, Types::Strict::String
        attribute :release, Types::Params::Bool

        def self.from_dynamic(dyn)
          ReleaseTag.new(to: dyn['to'],
                         what: dyn['what'],
                         date: dyn['date'],
                         who: dyn['who'],
                         release: dyn['release'])
        end
      end

      # Subschema for access concerns
      class Access < Dry::Struct
        attribute :embargoReleaseDate, Types::Params::DateTime.meta(omittable: true)

        def self.from_dynamic(dyn)
          params = {}
          params[:embargoReleaseDate] = dyn['embargoReleaseDate'] if dyn['embargoReleaseDate']
          Access.new(params)
        end
      end

      # Subschema for administrative concerns
      class Administrative < Dry::Struct
        attribute :releaseTags, Types::Strict::Array.of(ReleaseTag).meta(omittable: true)

        def self.from_dynamic(dyn)
          params = {}
          params[:releaseTags] = dyn['releaseTags'].map { |rt| ReleaseTag.from_dynamic(rt) } if dyn['releaseTags']
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

        params[:access] = Access.from_dynamic(dyn['access']) if dyn['access']
        params[:administrative] = Administrative.from_dynamic(dyn['administrative']) if dyn['administrative']

        DRO.new(params)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
