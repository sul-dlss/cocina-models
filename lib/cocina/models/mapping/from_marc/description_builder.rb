# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMarc
        # Creates Cocina Description objects from MARC records
        class DescriptionBuilder
          BUILDERS = {
            # TODO: implement these builders for MARC
            # note: Note,
            language: Language,
            contributor: Contributor,
            event: Event,
            # subject: Subject,
            # form: Form,
            identifier: Identifier
            # adminMetadata: AdminMetadata,
            # relatedResource: RelatedResource,
            # geographic: Geographic,
            # access: Access
          }.freeze

          # @param [MARC::Record] marc MARC record from FOLIO
          # @param [Cocina::Models::Mapping::ErrorNotifier] notifier
          # @param [TitleBuilder] title_builder - defaults to Title class
          # @param [String] purl
          # @return [Hash] a hash that can be mapped to a Cocina Description model
          def self.build(marc:, notifier:, title_builder: Title, purl: nil)
            new(title_builder: title_builder, notifier: notifier).build(marc: marc, purl: purl)
          end

          def initialize(notifier:, title_builder: Title)
            @title_builder = title_builder
            @notifier = notifier
          end

          # @return [Hash] a hash that can be mapped to a Cocina Description model
          def build(marc:, purl: nil, require_title: true)
            cocina_description = {}
            title_result = title_builder.build(marc: marc, require_title: require_title,
                                               notifier: notifier)
            cocina_description[:title] = title_result if title_result.present?
            cocina_description[:purl] = purl

            BUILDERS.each do |description_property, builder|
              result = builder.build(marc: marc)
              cocina_description.merge!(description_property => result) if result.present?
            end
            cocina_description
          end

          private

          attr_reader :notifier, :title_builder
        end
      end
    end
  end
end
