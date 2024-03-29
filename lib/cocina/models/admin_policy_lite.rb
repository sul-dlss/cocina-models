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
      attribute? :administrative, AdminPolicyAdministrative.optional
      attribute? :description, Description.optional
    end
  end
end
