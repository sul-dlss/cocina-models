# frozen_string_literal: true

module Cocina
  module Models
    class AdminPolicyLite < Struct
      include Checkable

      TYPES = ['https://cocina.sul.stanford.edu/models/admin_policy'].freeze

      # The version of Cocina with which this object conforms.
      # example: 1.2.3
      attribute :cocinaVersion, CocinaVersion.default(VERSION)
      attribute :type, Types::Strict::String.enum(*AdminPolicyLite::TYPES)
      # example: druid:bc123df4567
      attribute :externalIdentifier, Druid
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer
      # Administrative properties for an AdminPolicy
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute? :administrative, AdminPolicyAdministrative.optional
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute? :description, Description.optional
    end
  end
end
