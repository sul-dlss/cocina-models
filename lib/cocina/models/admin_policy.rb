# frozen_string_literal: true

module Cocina
  module Models
    class AdminPolicy < Struct
      include Validatable

      include Checkable

      TYPES = ['https://cocina.sul.stanford.edu/models/admin_policy'].freeze

      # The version of Cocina with which this object conforms.
      # example: 1.2.3
      attribute :cocina_version, Types::Strict::String.default(Cocina::Models::VERSION)
      attribute :type, Types::Strict::String.enum(*AdminPolicy::TYPES)
      # example: druid:bc123df4567
      attribute :external_identifier, Types::Strict::String
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer
      attribute(:administrative, AdminPolicyAdministrative.default { AdminPolicyAdministrative.new })
      attribute? :description, Description.optional

      alias cocinaVersion cocina_version
      deprecation_deprecate :cocinaVersion
      alias externalIdentifier external_identifier
      deprecation_deprecate :externalIdentifier
    end
  end
end
