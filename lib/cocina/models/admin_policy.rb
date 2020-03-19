# frozen_string_literal: true

module Cocina
  module Models
    class AdminPolicy < Struct
      include Checkable

      TYPES = ['http://cocina.sul.stanford.edu/models/admin_policy.jsonld'].freeze

      # example: item
      attribute :type, Types::Strict::String.enum(*AdminPolicy::TYPES)
      # example: druid:bc123df4567
      attribute :externalIdentifier, Types::Strict::String
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer
      attribute(:access, AdminPolicyAccess.default { AdminPolicyAccess.new })
      attribute(:administrative, AdminPolicyAdministrative.default { AdminPolicyAdministrative.new })
      attribute(:identification, AdminPolicyIdentification.default { AdminPolicyIdentification.new })
      attribute(:structural, AdminPolicyStructural.default { AdminPolicyStructural.new })
      attribute :description, Description.optional.meta(omittable: true)
    end
  end
end
