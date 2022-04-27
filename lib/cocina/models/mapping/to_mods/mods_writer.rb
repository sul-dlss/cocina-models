# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module ToMods
        # Maps description resource from cocina to MODS XML
        class ModsWriter
          # @params [Nokogiri::XML::Builder] xml
          # @param [Cocina::Models::Description] description
          # @param [string] druid
          def self.write(xml:, description:, druid:, id_generator: IdGenerator.new)
            # ID Generator makes sure that different writers create unique altRepGroups and nameTitleGroups.
            if description.title
              Title.write(xml: xml, titles: description.title, contributors: description.contributor,
                          id_generator: id_generator)
            end
            Contributor.write(xml: xml, contributors: description.contributor, titles: description.title,
                              id_generator: id_generator)
            Form.write(xml: xml, forms: description.form, id_generator: id_generator)
            Language.write(xml: xml, languages: description.language)
            Note.write(xml: xml, notes: description.note, id_generator: id_generator)
            Subject.write(xml: xml, subjects: description.subject, forms: description.form,
                          id_generator: id_generator)
            Event.write(xml: xml, events: description.event, id_generator: id_generator)
            Identifier.write(xml: xml, identifiers: description.identifier, id_generator: id_generator)
            Access.write(xml: xml, access: description.access,
                         purl: description.respond_to?(:purl) ? description.purl : nil)
            AdminMetadata.write(xml: xml, admin_metadata: description.adminMetadata)
            RelatedResource.write(xml: xml, related_resources: description.relatedResource, druid: druid,
                                  id_generator: id_generator)
            Geographic.write(xml: xml, geos: description.geographic, druid: druid) if description.respond_to?(:geographic)
          end
        end
      end
    end
  end
end
