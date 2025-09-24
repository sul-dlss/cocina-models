# frozen_string_literal: true

require 'active_support/all'

module Cocina
  module Models
    module Mapping
      module ToDatacite
        # Maps description resource from cocina to DataCite JSON
        class Request
          # @param [Cocina::Models::DRO] cocina_object
          def self.build(...)
            new(...).call
          end

          def initialize(cocina_object:)
            @cocina_object = cocina_object

            # Set the time zone
            Time.zone = 'Pacific Time (US & Canada)'
          end

          attr_reader :cocina_object

          delegate :access, :description, :identification, to: :cocina_object

          def call
            {
              event: 'publish',
              url: description.purl,
              identifiers: Identifiers.build(identification:),
              titles: Titles.build(description),
              publisher: 'Stanford Digital Repository', # per DataCite schema
              publicationYear: publication_year,
              subjects: Subject.build(description),
              dates: [],
              language: 'en',
              types: Types.build(description),
              alternateIdentifiers: AlternateIdentifiers.build(description:),
              relatedIdentifiers: related_identifiers,
              # attributes[:sizes] = Sizes.build(cocina_object: cocina_object)
              # attributes[:formats] = Formats.build(cocina_object: cocina_object)
              # attributes[:version] = identification.version if identification.version
              rightsList: RightsList.build(access:),
              descriptions: Descriptions.build(description:),
              # attributes[:geoLocations] = GeoLocations.build(cocina_object: cocina_object)
              relatedItems: related_items
            }.merge(ContributorAttributes.build(description)).compact
          end

          private

          def publication_year
            date = if access.embargo
                     access.embargo.releaseDate.to_datetime
                   else
                     Time.zone.today
                   end
            date.year.to_s
          end

          def related_identifiers
            Array(description&.relatedResource).filter_map do |related_resource|
              RelatedResource.related_identifier_attributes(related_resource)
            end
          end

          def related_items
            Array(description&.relatedResource).filter_map do |related_resource|
              RelatedResource.related_item_attributes(related_resource)
            end
          end
        end
      end
    end
  end
end
