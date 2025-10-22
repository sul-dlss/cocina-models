# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module ToDatacite
        # Transform the Cocina::Models::Description relatedResource attributes to the DataCite relatedItem attributes
        #  see https://support.datacite.org/reference/dois-2#put_dois-id
        class RelatedResource
          # @param [Cocina::Models::RelatedResource] related_resource
          # @return [Hash] Hash of DataCite relatedItem attributes, conforming to the expectations of HTTP PUT
          # request to DataCite or nil if blank
          #  see https://support.datacite.org/reference/dois-2#put_dois-id
          def self.related_item_attributes(...)
            new(...).related_item_attributes
          end

          # @param [Cocina::Models::RelatedResource] related_resource
          # @return [Hash] Hash of DataCite relatedIdentifier attributes, conforming to the expectations of HTTP PUT
          # request to DataCite or nil if blank
          #  see https://support.datacite.org/reference/dois-2#put_dois-id
          def self.related_identifier_attributes(...)
            new(...).related_identifier_attributes
          end

          def initialize(related_resource:)
            @related_resource = related_resource
          end

          # @return [Hash,nil] Array of DataCite relatedItem attributes, conforming to the expectations of HTTP PUT
          # request to DataCite or nil if blank
          #  see https://support.datacite.org/reference/dois-2#put_dois-id
          def related_item_attributes # rubocop:disable Metrics/MethodLength
            return if related_resource_blank?

            {
              relatedItemType: 'Other',
              relationType: relation_type
            }.tap do |attribs|
              attribs[:titles] = [title: related_item_title] if related_item_title
              if related_item_identifier_url
                attribs[:relatedItemIdentifier] = {
                  relatedItemIdentifier: related_item_identifier_url,
                  relatedItemIdentifierType: 'URL'
                }
              end

              if related_item_doi
                attribs[:relatedItemIdentifier] = {
                  relatedItemIdentifier: related_item_doi,
                  relatedItemIdentifierType: 'DOI'
                }
              end
            end
          end

          # @return [Hash,nil] Array of DataCite relatedIdentifier attributes, conforming to the expectations of HTTP PUT
          # request to DataCite or nil if blank
          #  see https://support.datacite.org/reference/dois-2#put_dois-id
          def related_identifier_attributes
            return if related_identifier_blank?

            {
              resourceTypeGeneral: 'Other',
              relationType: relation_type
            }.tap do |attribs|
              if related_item_identifier_url
                attribs[:relatedIdentifier] = related_item_identifier_url
                attribs[:relatedIdentifierType] = 'URL'
              end

              if related_item_doi
                attribs[:relatedIdentifier] = related_item_doi
                attribs[:relatedIdentifierType] = 'DOI'
              end
            end
          end

          private

          attr_reader :related_resource

          def relation_type
            related_resource.dataCiteRelationType || 'References'
          end

          def related_resource_blank?
            return true if related_resource.blank?

            related_resource_hash = related_resource.to_h.slice(:note, :title, :access, :identifier)
            related_resource_hash.blank? || related_resource_hash.each_value.all?(&:blank?)
          end

          def related_identifier_blank?
            return true if related_resource.blank?

            related_resource_hash = related_resource.to_h.slice(:access, :identifier)
            related_resource_hash.blank? || related_resource_hash.each_value.all?(&:blank?)
          end

          def related_item_title
            @related_item_title ||= preferred_citation || other_title || related_item_doi || related_item_identifier_url
          end

          # example cocina relatedResource:
          #   {
          #     note: [
          #       {
          #         value: 'Stanford University (Stanford, CA.). (2020). yadda yadda',
          #         type: 'preferred citation'
          #       }
          #     ]
          #   }
          def preferred_citation
            Array(related_resource.note).find do |note|
              note.type == 'preferred citation' && note.value.present?
            end&.value
          end

          # example cocina relatedResource:
          #   {
          #     title: [
          #       {
          #         value: 'A paper'
          #       }
          #     ]
          #   }
          def other_title
            Array(related_resource.title).find do |title|
              title.value.present?
            end&.value
          end

          def related_item_doi
            Array(related_resource.identifier).find do |identifier|
              identifier.type == 'doi' && identifier.uri.present?
            end&.uri
          end

          # example cocina relatedResource:
          #   {
          #     access: {
          #       url: [
          #         {
          #           value: 'https://www.example.com/paper.html'
          #         }
          #       ]
          #     }
          #   }
          def related_item_identifier_url
            @related_item_identifier_url ||= Array(related_resource.access&.url).find do |url|
              url.value.present?
            end&.value
          end
        end
      end
    end
  end
end
