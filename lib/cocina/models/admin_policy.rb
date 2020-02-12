# frozen_string_literal: true

module Cocina
  module Models
    # An admin policy object.
    class AdminPolicy < Dry::Struct
      include Checkable

      TYPES = [
        Vocab.admin_policy
      ].freeze

      # Subschema for access concerns
      class Access < Dry::Struct
        def self.from_dynamic(_dyn)
          params = {}
          Access.new(params)
        end
      end

      # Subschema for administrative concerns
      class Administrative < Dry::Struct
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

        # Allowing hasAdminPolicy to be omittable for now (until rolled out to consumers),
        # but I think it's actually required for every Admin Policy
        attribute :hasAdminPolicy, Types::Coercible::String.optional.default(nil)

        def self.from_dynamic(dyn)
          params = {
            default_object_rights: dyn['default_object_rights'],
            registration_workflow: dyn['registration_workflow']
          }
          params[:hasAdminPolicy] = dyn['hasAdminPolicy']
          Administrative.new(params)
        end
      end

      class Identification < Dry::Struct
      end

      class Structural < Dry::Struct
      end

      attribute :externalIdentifier, Types::Strict::String
      attribute :type, Types::String.enum(*TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Coercible::Integer
      attribute(:access, Access.default { Access.new })
      attribute(:administrative, Administrative.default { Administrative.new })
      # Allowing description to be omittable for now (until rolled out to consumers),
      # but I think it's actually required for every DRO
      attribute :description, Description.optional.default(nil)
      attribute(:identification, Identification.default { Identification.new })
      attribute(:structural, Structural.default { Structural.new })

      def self.from_dynamic(dyn)
        params = {
          externalIdentifier: dyn['externalIdentifier'],
          type: dyn['type'],
          label: dyn['label'],
          version: dyn['version']
        }

        # params[:access] = Access.from_dynamic(dyn['access']) if dyn['access']
        params[:administrative] = Administrative.from_dynamic(dyn['administrative']) if dyn['administrative']
        params[:description] = Description.from_dynamic(dyn.fetch('description'))
        AdminPolicy.new(params)
      end

      def self.from_json(json)
        from_dynamic(JSON.parse(json))
      end
    end
  end
end
