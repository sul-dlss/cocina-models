# frozen_string_literal: true

module Cocina
  module Models
    class RequestAdminPolicy < Struct
      include Validatable

      include Checkable

      TYPES = ['https://cocina.sul.stanford.edu/models/admin_policy'].freeze

      # The version of Cocina with which this object conforms.
      # example: 1.2.3
      attribute :cocina_version, Types::Strict::String.default(Cocina::Models::VERSION)
      attribute :type, Types::Strict::String.enum(*RequestAdminPolicy::TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer.default(1).enum(1)
      attribute(:administrative, AdminPolicyAdministrative.default { AdminPolicyAdministrative.new })
      attribute :description, RequestDescription.optional.meta(omittable: true)

      def method_missing(method_name, *arguments, &block)
        if [:cocinaVersion].include?(method_name)
          Deprecation.warn(
            self,
            "the `#{method_name}` attribute is deprecated and will be removed in the cocina-models 1.0.0 release"
          )
          public_send(method_name.to_s.underscore, *arguments, &block)
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        [:cocinaVersion].include?(method_name) || super
      end
    end
  end
end
