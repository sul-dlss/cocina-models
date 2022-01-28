# frozen_string_literal: true

module Cocina
  module Models
    class AdminPolicyAdministrative < Struct
      attribute(:access_template, AdminPolicyAccessTemplate.default { AdminPolicyAccessTemplate.new })
      attribute :registration_workflow, Types::Strict::Array.of(Types::Strict::String).default([].freeze)
      # An additional workflow to start for objects managed by this admin policy once the end-accession workflow step is complete
      # example: wasCrawlPreassemblyWF
      attribute :dissemination_workflow, Types::Strict::String.meta(omittable: true)
      attribute :collections_for_registration, Types::Strict::Array.of(Types::Strict::String).default([].freeze)
      # example: druid:bc123df4567
      attribute :has_admin_policy, Types::Strict::String
      # example: druid:bc123df4567
      attribute :has_agreement, Types::Strict::String
      attribute :roles, Types::Strict::Array.of(AccessRole).default([].freeze)

      def method_missing(method_name, *arguments, &block)
        if %i[accessTemplate registrationWorkflow disseminationWorkflow collectionsForRegistration hasAdminPolicy hasAgreement].include?(method_name)
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
        %i[accessTemplate registrationWorkflow disseminationWorkflow collectionsForRegistration hasAdminPolicy hasAgreement].include?(method_name) || super
      end
    end
  end
end
