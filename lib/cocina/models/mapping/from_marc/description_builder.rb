# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMarc
        # Creates Cocina Description objects from MARC records
        class DescriptionBuilder
          BUILDERS = {
            # TODO: implement these builders for MARC
            title: Title,
            # NOTE: Note,
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
          # @param [String] purl
          # @return [Hash] a hash that can be mapped to a Cocina Description model
          def self.build(marc:, notifier:, purl: nil)
            new(notifier: notifier).build(marc: marc, purl: purl)
          end

          def initialize(notifier:)
            @notifier = notifier
          end

          # @return [Hash] a hash that can be mapped to a Cocina Description model
          def build(marc:, purl: nil, require_title: true)
            cocina_description = { purl: }

            BUILDERS.each do |description_property, builder|
              kwargs = { marc: }
              kwargs.merge!(notifier:, require_title:) if builder.method(:build).parameters.map(&:second).include?(:notifier)

              result = builder.build(**kwargs)
              cocina_description.merge!(description_property => result) if result.present?
            end
            cocina_description
          end

          private

          attr_reader :notifier
        end
      end
    end
  end
end
