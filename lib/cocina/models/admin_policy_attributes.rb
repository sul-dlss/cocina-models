# frozen_string_literal: true

module Cocina
  module Models
    # attributes common to both AdminPolicy and RequestAdminPolicy
    module AdminPolicyAttributes
      def self.included(obj)
        obj.attribute(:access, AdminPolicy::Access.default { AdminPolicy::Access.new })
        obj.attribute(:administrative, AdminPolicy::Administrative.default { AdminPolicy::Administrative.new })
        # TODO: Allowing description to be omittable for now (until rolled out to consumers),
        # but I think it's actually required for every admin policy
        obj.attribute :description, Description.optional.meta(omittable: true)
        obj.attribute(:identification, AdminPolicy::Identification.default { AdminPolicy::Identification.new })
        obj.attribute :label, Types::Strict::String
        obj.attribute(:structural, AdminPolicy::Structural.default { AdminPolicy::Structural.new })
        obj.attribute :type, Types::String.enum(*AdminPolicy::TYPES)
        obj.attribute :version, Types::Strict::Integer
      end
    end
  end
end
