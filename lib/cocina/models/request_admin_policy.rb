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
      attribute(:administrative, AdminPolicyAdministrative.default { AdminPolicyAdministrative.new })
      attribute :description, Description.optional.meta(omittable: true)

      def self.new(attributes = default_attributes, safe = false, validate = true, &block)
        Validator.validate(self, attributes.with_indifferent_access) if validate
        super(attributes, safe, &block)
      end
    end
  end
end
