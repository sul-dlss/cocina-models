# frozen_string_literal: true

module Cocina
  module Models
    class AdminPolicy < Struct
      include Validatable

      include Checkable

      TYPES = ['https://cocina.sul.stanford.edu/models/admin_policy'].freeze

      # The version of Cocina with which this object conforms.
      # example: 1.2.3
      attribute :cocinaVersion, CocinaVersion.default(VERSION)
      attribute :type, Types::Strict::String.enum(*AdminPolicy::TYPES)
      # example: druid:bc123df4567
      attribute :externalIdentifier, Druid
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer
      # Administrative properties for an AdminPolicy
      attribute(:administrative, AdminPolicyAdministrative.default { AdminPolicyAdministrative.new })
      attribute? :description, Description.optional
    end
  end
end
