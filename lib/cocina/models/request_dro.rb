# frozen_string_literal: true

module Cocina
  module Models
    # A request to create a digital repository object.
    # This is the same as a DRO, but without externalIdentifier (as that wouldn't have been created yet)
    # See http://sul-dlss.github.io/cocina-models/maps/DRO.json
    class RequestDRO < Struct
      include DroAttributes

      # Structural sub-schema that contains RequestFileSet (unlike the DRO which contains FileSet)
      class Structural < Struct
        attribute :contains, Types::Strict::Array.of(RequestFileSet).meta(omittable: true)
        attribute :isMemberOf, Types::Strict::String.meta(omittable: true)
        attribute :hasMemberOrders, Types::Strict::Array.of(Sequence).meta(omittable: true)
      end

      attribute(:structural, Structural.default { Structural.new })

      def self.from_dynamic(dyn)
        RequestDRO.new(dyn)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
