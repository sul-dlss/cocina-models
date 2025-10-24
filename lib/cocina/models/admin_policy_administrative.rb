# frozen_string_literal: true

module Cocina
  module Models
    # Administrative properties for an AdminPolicy
    class AdminPolicyAdministrative < Struct
      # Provides the template of access settings that is copied to the items governed by
      # an AdminPolicy. This is almost the same as DROAccess, but it provides no defaults
      # and has no embargo.
      attribute(:accessTemplate, AdminPolicyAccessTemplate.default { AdminPolicyAccessTemplate.new })
      # When you register an item with this admin policy, these are the workflows that are
      # available.
      attribute :registrationWorkflow, Types::Strict::Array.of(Types::Strict::String).default([].freeze)
      # An additional workflow to start for objects managed by this admin policy once the
      # end-accession workflow step is complete
      # example: wasCrawlPreassemblyWF
      attribute? :disseminationWorkflow, Types::Strict::String
      # When you register an item with this admin policy, these are the collections that
      # are available.
      attribute :collectionsForRegistration, Types::Strict::Array.of(Types::Strict::String).default([].freeze)
      # example: druid:bc123df4567
      attribute :hasAdminPolicy, Druid
      # example: druid:bc123df4567
      attribute :hasAgreement, Druid
      # The access roles conferred by this AdminPolicy (used by Argo)
      attribute :roles, Types::Strict::Array.of(AccessRole).default([].freeze)
    end
  end
end
