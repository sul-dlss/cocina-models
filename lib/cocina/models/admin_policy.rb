# frozen_string_literal: true

module Cocina
  module Models
    class AdminPolicy < Struct
      include Checkable

      TYPES = ['http://cocina.sul.stanford.edu/models/admin_policy.jsonld'].freeze

      attribute :type, Types::Strict::String.enum(*AdminPolicy::TYPES)
      # example: druid:bc123df4567
      attribute :externalIdentifier, Types::Strict::String
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer
      attribute(:administrative, AdminPolicyAdministrative.default { AdminPolicyAdministrative.new })
      attribute :description, Description.optional.meta(omittable: true)

      def self.new(attributes = default_attributes, safe = false, validate = true, &block)
        Validator.validate(self, attributes.with_indifferent_access) if validate && name
        super(attributes, safe, &block)
      end
    end
  end
end
