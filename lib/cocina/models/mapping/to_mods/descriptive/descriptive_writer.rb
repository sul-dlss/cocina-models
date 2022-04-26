# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module ToMods
        class Descriptive
          # Maps descriptive resource from cocina to MODS XML
          class DescriptiveWriter
            # @params [Nokogiri::XML::Builder] xml
            # @param [Cocina::Models::Description] descriptive
            # @param [string] druid
            def self.write(xml:, descriptive:, druid:, id_generator: Descriptive::IdGenerator.new)
              # ID Generator makes sure that different writers create unique altRepGroups and nameTitleGroups.
              if descriptive.title
                Title.write(xml: xml, titles: descriptive.title, contributors: descriptive.contributor,
                            id_generator: id_generator)
              end
              Contributor.write(xml: xml, contributors: descriptive.contributor, titles: descriptive.title,
                                id_generator: id_generator)
              Form.write(xml: xml, forms: descriptive.form, id_generator: id_generator)
              Language.write(xml: xml, languages: descriptive.language)
              Note.write(xml: xml, notes: descriptive.note, id_generator: id_generator)
              Subject.write(xml: xml, subjects: descriptive.subject, forms: descriptive.form,
                            id_generator: id_generator)
              Descriptive::Event.write(xml: xml, events: descriptive.event, id_generator: id_generator)
              Identifier.write(xml: xml, identifiers: descriptive.identifier, id_generator: id_generator)
              Descriptive::Access.write(xml: xml, access: descriptive.access,
                                        purl: descriptive.respond_to?(:purl) ? descriptive.purl : nil)
              AdminMetadata.write(xml: xml, admin_metadata: descriptive.adminMetadata)
              RelatedResource.write(xml: xml, related_resources: descriptive.relatedResource, druid: druid,
                                    id_generator: id_generator)
              Geographic.write(xml: xml, geos: descriptive.geographic, druid: druid) if descriptive.respond_to?(:geographic)
            end
          end
        end
      end
    end
  end
end
