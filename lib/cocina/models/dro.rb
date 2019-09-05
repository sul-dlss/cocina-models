# frozen_string_literal: true

require 'json'

module Cocina
  module Models
    # A digital repository object.  See https://github.com/sul-dlss-labs/taco/blob/master/maps/DRO.json
    class DRO < Dry::Struct
      attribute :externalIdentifier, Types::Strict::String
      attribute :type, Types::Strict::String
      attribute :label, Types::Strict::String

      def self.from_dynamic(d)
        DRO.new(
          externalIdentifier: d['externalIdentifier'],
          type: d['type'],
          label: d['label']
        )
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
