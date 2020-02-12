# frozen_string_literal: true

module Cocina
  module Models
    # An request to create an AdminPolicy object.
    # This is the same as AdminPolicy, except it doesn't have externalIdentifier.
    class RequestAdminPolicy < Dry::Struct
      attribute :type, Types::String.enum(*AdminPolicy::TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Coercible::Integer
      attribute(:access, AdminPolicy::Access.default { AdminPolicy::Access.new })
      attribute(:administrative, AdminPolicy::Administrative.default { AdminPolicy::Administrative.new })
      # Allowing description to be omittable for now (until rolled out to consumers),
      # but I think it's actually required for every DRO
      attribute :description, Description.optional.default(nil)
      attribute(:identification, AdminPolicy::Identification.default { AdminPolicy::Identification.new })
      attribute(:structural, AdminPolicy::Structural.default { AdminPolicy::Structural.new })

      def self.from_dynamic(dyn)
        AdminPolicyBuilder.build(self, dyn)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
