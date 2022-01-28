# frozen_string_literal: true

module Cocina
  module Models
    class AdminPolicyWithMetadata < Struct
      include Validatable

      include Checkable

      TYPES = ['https://cocina.sul.stanford.edu/models/admin_policy'].freeze

      # The version of Cocina with which this object conforms.
      # example: 1.2.3
      attribute :cocina_version, Types::Strict::String.default(Cocina::Models::VERSION)
      attribute :type, Types::Strict::String.enum(*AdminPolicyWithMetadata::TYPES)
      # example: druid:bc123df4567
      attribute :external_identifier, Types::Strict::String
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer
      attribute(:administrative, AdminPolicyAdministrative.default { AdminPolicyAdministrative.new })
      attribute :description, Description.optional.meta(omittable: true)
      # When the object was created.
      attribute :created, Types::Params::DateTime.meta(omittable: true)
      # When the object was modified.
      attribute :modified, Types::Params::DateTime.meta(omittable: true)
      # Key for optimistic locking. The contents of the key is not specified.
      attribute :lock, Types::Strict::String
    end
  end
end
