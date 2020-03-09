# frozen_string_literal: true

module Cocina
  module Models
    # An admin policy object.
    class AdminPolicy < Struct
      include Checkable

      TYPES = [
        Vocab.admin_policy
      ].freeze

      # Subschema for access concerns
      class Access < Struct
      end

      # Subschema for administrative concerns
      class Administrative < Struct
        # This was copied from the ActiveFedora defaults: Dor::AdminPolicyObject.new.defaultObjectRights.content
        DEFAULT_OBJECT_RIGHTS = <<~XML
          <?xml version="1.0" encoding="UTF-8"?>

          <rightsMetadata>
             <access type="discover">
                <machine>
                   <world/>
                </machine>
             </access>
             <access type="read">
                <machine>
                   <world/>
                </machine>
             </access>
             <use>
                <human type="useAndReproduction"/>
                <human type="creativeCommons"/>
                <machine type="creativeCommons" uri=""/>
                <human type="openDataCommons"/>
                <machine type="openDataCommons" uri=""/>
             </use>
             <copyright>
                <human/>
             </copyright>
          </rightsMetadata>
        XML

        # An XML blob that is to be used temporarily until we model rights
        attribute :default_object_rights, Types::Strict::String.optional.default(DEFAULT_OBJECT_RIGHTS)

        # which workflow to start when registering (used by Web Archive apos to start wasCrawlPreassemblyWF)
        attribute :registration_workflow, Types::String.optional.default(nil)

        # TODO: Allowing hasAdminPolicy to be omittable for now (until rolled out to consumers),
        # but I think it's actually required for every Admin Policy
        attribute :hasAdminPolicy, Types::Coercible::String.optional.default(nil)
      end

      class Identification < Struct
      end

      class Structural < Struct
      end

      include AdminPolicyAttributes
      attribute :externalIdentifier, Types::Strict::String
    end
  end
end
