# frozen_string_literal: true

module Cocina
  module Models
    class RequestAdminPolicy < Struct
      include Checkable

      TYPES = ['http://cocina.sul.stanford.edu/models/admin_policy.jsonld'].freeze

      # example: item
      attribute :type, Types::Strict::String.enum(*RequestAdminPolicy::TYPES)
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
