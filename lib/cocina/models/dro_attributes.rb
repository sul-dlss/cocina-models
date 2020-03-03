# frozen_string_literal: true

module Cocina
  module Models
    # attributes common to both DRO and RequestDRO
    # See http://sul-dlss.github.io/cocina-models/maps/DRO.json
    module DroAttributes
      def self.included(obj)
        obj.attribute(:access, DRO::Access.default { DRO::Access.new })
        obj.attribute(:administrative, DRO::Administrative.default { DRO::Administrative.new })
        # Allowing description to be omittable for now (until rolled out to consumers),
        # but I think it's actually required for every DRO
        obj.attribute :description, Description.optional.meta(omittable: true)
        obj.attribute :geographic, DRO::Geographic.optional.meta(omittable: true)
        obj.attribute(:identification, DRO::Identification.default { DRO::Identification.new })
        obj.attribute :label, Types::Strict::String
        obj.attribute :type, Types::String.enum(*DRO::TYPES)
        obj.attribute :version, Types::Coercible::Integer
      end
    end
  end
end
