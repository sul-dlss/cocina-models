# frozen_string_literal: true

module Cocina
  module Models
    # A Request to create a digital repository object. (to create) object.
    # This is same as a DRO, but without externalIdentifier (as that wouldn't have been created yet)
    # See http://sul-dlss.github.io/cocina-models/maps/DRO.json
    class RequestDRO < Struct
      attribute :type, Types::String.enum(*DRO::TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Coercible::Integer
      attribute(:access, DRO::Access.default { DRO::Access.new })
      attribute(:administrative, DRO::Administrative.default { DRO::Administrative.new })
      # Allowing description to be omittable for now (until rolled out to consumers),
      # but I think it's actually required for every DRO
      attribute :description, Description.optional.meta(omittable: true)
      attribute(:identification, DRO::Identification.default { DRO::Identification.new })
      attribute(:structural, DRO::Structural.default { DRO::Structural.new })

      def self.from_dynamic(dyn)
        RequestDRO.new(dyn)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
