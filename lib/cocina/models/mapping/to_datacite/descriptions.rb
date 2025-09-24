# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module ToDatacite
        # Transform the Cocina::Models::Description note attributes to the DataCite descriptions attributes
        #  see https://support.datacite.org/reference/dois-2#put_dois-id
        class Descriptions
          # @param [Cocina::Models::Description] cocina_desc
          # @return [NilClass, Array<Hash>] list of DataCite descriptions attributes, conforming to the expectations of
          # HTTP PUT request to DataCite
          def self.build(...)
            new(...).call
          end

          def initialize(description:)
            @description = description
          end

          # @return [NilClass, Array<Hash>] list of DataCite descriptions attributes, conforming to the expectations of
          # HTTP PUT request to DataCite
          def call
            return unless abstract

            [{
              description: abstract,
              descriptionType: 'Abstract'
            }]
          end

          private

          attr_reader :description

          def abstract
            @abstract ||= Array(description.note).find { |cocina_note| cocina_note.type == 'abstract' }&.value
          end
        end
      end
    end
  end
end
