# frozen_string_literal: true

require 'json'

module Cocina
  module Models
    # A digital repository object.  See https://github.com/sul-dlss-labs/taco/blob/master/maps/DRO.json
    class DRO < Dry::Struct
      attribute :externalIdentifier, Types::Strict::String
      attribute :type, Types::Strict::String
      attribute :label, Types::Strict::String
      attribute :access, Dry::Struct.meta(omittable: true) do
        attribute :embargoReleaseDate, Types::Params::DateTime
      end

      def self.from_dynamic(d)
        params = {
          externalIdentifier: d['externalIdentifier'],
          type: d['type'],
          label: d['label']
        }
        if d['access']
          access = {
            embargoReleaseDate: d['access']['embargoReleaseDate']
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
