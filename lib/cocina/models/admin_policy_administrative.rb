# frozen_string_literal: true

module Cocina
  module Models
    class AdminPolicyAdministrative < Struct
      attribute(:defaultAccess, AdminPolicyDefaultAccess.default { AdminPolicyDefaultAccess.new })
      attribute :registrationWorkflow, Types::Strict::Array.of(Types::Strict::String).default([].freeze)
      # An additional workflow to start for objects managed by this admin policy once the end-accession workflow step is complete
      # example: wasCrawlPreassemblyWF
      attribute :disseminationWorkflow, Types::Strict::String.meta(omittable: true)
      attribute :collectionsForRegistration, Types::Strict::Array.of(Types::Strict::String).default([].freeze)
      # example: druid:bc123df4567
      attribute :hasAdminPolicy, Types::Strict::String
      # example: druid:bc123df4567
      attribute :hasAgreement, Types::Strict::String
      attribute :roles, Types::Strict::Array.of(AccessRole).default([].freeze)
    end
  end
end
