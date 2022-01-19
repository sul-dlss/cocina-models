# frozen_string_literal: true

module Cocina
  module Models
    class AdminPolicyAdministrative < Struct
      # This is an XML expression of the default access (see defaultAccess)
      attribute :defaultObjectRights, Types::Strict::String.default('<?xml version="1.0" encoding="UTF-8"?><rightsMetadata><access type="discover"><machine><world/></machine></access><access type="read"><machine><world/></machine></access><use><human type="useAndReproduction"/><human type="creativeCommons"/><machine type="creativeCommons" uri=""/><human type="openDataCommons"/><machine type="openDataCommons" uri=""/></use><copyright><human/></copyright></rightsMetadata>').meta(omittable: true)
      attribute :defaultAccess, AdminPolicyDefaultAccess.optional.meta(omittable: true)
      attribute :registrationWorkflow, Types::Strict::Array.of(Types::Strict::String).default([])
      # An additional workflow to start for objects managed by this admin policy once the end-accession workflow step is complete
      # example: wasCrawlPreassemblyWF
      attribute :disseminationWorkflow, Types::Strict::String.meta(omittable: true)
      attribute :collectionsForRegistration, Types::Strict::Array.of(Types::Strict::String).default([])
      # example: druid:bc123df4567
      attribute :hasAdminPolicy, Types::Strict::String
      # example: druid:bc123df4567
      attribute :referencesAgreement, Types::Strict::String.meta(omittable: true)
      attribute :roles, Types::Strict::Array.of(AccessRole).default([])
    end
  end
end
