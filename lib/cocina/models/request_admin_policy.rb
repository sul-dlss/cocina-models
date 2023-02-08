# frozen_string_literal: true

module Cocina
  module Models
    # Same as an AdminPolicy, but doesn't have an externalIdentifier as one will be created
    class RequestAdminPolicy < Struct
      include Validatable

      include Checkable

      TYPES = ['https://cocina.sul.stanford.edu/models/admin_policy'].freeze

      # The version of Cocina with which this object conforms.
      # example: 1.2.3
      attribute :cocinaVersion, CocinaVersion.default(VERSION)
      attribute :type, Types::Strict::String.enum(*RequestAdminPolicy::TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer.default(1).enum(1)
      attribute(:administrative, AdminPolicyAdministrative.default { AdminPolicyAdministrative.new })
      attribute? :description, RequestDescription.optional
    end
  end
end
