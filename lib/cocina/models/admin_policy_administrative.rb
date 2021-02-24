# frozen_string_literal: true

module Cocina
  module Models
    class AdminPolicyAdministrative < Struct
      attribute :defaultObjectRights, Types::Strict::String.default('<?xml version="1.0" encoding="UTF-8"?><rightsMetadata><access type="discover"><machine><world/></machine></access><access type="read"><machine><world/></machine></access><use><human type="useAndReproduction"/><human type="creativeCommons"/><machine type="creativeCommons" uri=""/><human type="openDataCommons"/><machine type="openDataCommons" uri=""/></use><copyright><human/></copyright></rightsMetadata>').meta(omittable: true)
      attribute :registrationWorkflow, Types::Strict::String.meta(omittable: true)
      attribute :collectionsForRegistration, Types::Strict::Array.of(Types::Strict::String).meta(omittable: true)
      attribute :hasAdminPolicy, Types::Strict::String
    end
  end
end
