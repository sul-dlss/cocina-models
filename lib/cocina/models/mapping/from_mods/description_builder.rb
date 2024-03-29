# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMods
        # Creates Cocina Description objects from MODS resource element.
        class DescriptionBuilder
          attr_reader :notifier

          BUILDERS = {
            note: Note,
            language: Language,
            contributor: Contributor,
            event: Event,
            subject: Subject,
            form: Form,
            identifier: Identifier,
            adminMetadata: AdminMetadata,
            relatedResource: RelatedResource,
            geographic: Geographic,
            access: Access
          }.freeze

          # @param [Nokogiri::XML::Element] resource_element mods or relatedItem element
          # @param [Cocina::Models::Mapping::ErrorNotifier] notifier
          # @param [TitleBuilder] title_builder - defaults to Title class
          # @param [String] purl
          # @return [Hash] a hash that can be mapped to a cocina description model
          def self.build(resource_element:, notifier:, title_builder: Title, purl: nil)
            new(title_builder: title_builder, notifier: notifier).build(resource_element: resource_element,
                                                                        purl: purl)
          end

          def initialize(notifier:, title_builder: Title)
            @title_builder = title_builder
            @notifier = notifier
          end

          # @return [Hash] a hash that can be mapped to a cocina description model
          def build(resource_element:, purl: nil, require_title: true)
            cocina_description = {}
            title_result = @title_builder.build(resource_element: resource_element, require_title: require_title,
                                                notifier: notifier)
            cocina_description[:title] = title_result if title_result.present?

            purl_value = purl || Purl.primary_purl_value(resource_element, purl)
            cocina_description[:purl] = purl_value if purl_value

            BUILDERS.each do |description_property, builder|
              result = builder.build(resource_element: resource_element, description_builder: self,
                                     purl: purl_value)
              cocina_description.merge!(description_property => result) if result.present?
            end
            cocina_description
          end
        end
      end
    end
  end
end
