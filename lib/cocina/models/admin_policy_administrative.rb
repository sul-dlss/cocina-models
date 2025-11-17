# frozen_string_literal: true

module Cocina
  module Models
    # Administrative properties for an AdminPolicy
    class AdminPolicyAdministrative < BaseModel
      attr_accessor :accessTemplate, :registrationWorkflow, :disseminationWorkflow, :collectionsForRegistration, :hasAdminPolicy, :hasAgreement, :roles
    end
  end
end
