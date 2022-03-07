# frozen_string_literal: true

module Cocina
  module Models
    class AdminPolicy < Struct
      include Validatable

      include Checkable

      include TitleBuilder

      TYPES = ['https://cocina.sul.stanford.edu/models/admin_policy'].freeze

      # The version of Cocina with which this object conforms.
      # example: 1.2.3
      attribute :cocinaVersion, Types::Strict::String.default(Cocina::Models::VERSION)
      attribute :type, Types::Strict::String.enum(*AdminPolicy::TYPES)
      # example: druid:bc123df4567
      attribute :externalIdentifier, Types::Strict::String
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer
      attribute(:administrative, AdminPolicyAdministrative.default { AdminPolicyAdministrative.new })
      attribute :description, Description.optional.meta(omittable: true)
    end
  end
end
