# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module ToDatacite
        # Transform the Cocina::Models::Description subjects attributes to the DataCite subjects attributes
        #  see https://support.datacite.org/reference/dois-2#put_dois-id
        class Subject
          # @param [Cocina::Models::Description] description
          # @return [NilClass,Array<Hash>] list of DataCite subjects attributes, conforming to the expectations of
          # HTTP PUT request to DataCite
          def self.build(...)
            new(...).call
          end

          def initialize(description:)
            @description = description
          end

          # @return [NilClass,Array<Hash>] list of DataCite subjects attributes, conforming to the expectations of
          # HTTP PUT request to DataCite
          def call
            return if description&.subject.blank?

            results = description.subject.map do |cocina_subject|
              subject(cocina_subject)
            end
            results.compact.presence
          end

          private

          attr_reader :description

          def subject(cocina_subject)
            return if cocina_subject.blank?

            if fast?(cocina_subject)
              fast_subject(cocina_subject)
            else
              non_fast_subject(cocina_subject)
            end
          end

          def fast_subject(cocina_subject)
            {
              subjectScheme: 'fast',
              schemeUri: 'http://id.worldcat.org/fast/'

            }.tap do |attribs|
              attribs[:subject] = cocina_subject.value if cocina_subject.value.present?
              attribs[:valueUri] = cocina_subject.uri if cocina_subject.uri.present?
            end
          end

          def non_fast_subject(cocina_subject)
            return if cocina_subject.value.blank?

            { subject: cocina_subject.value }
          end

          def fast?(cocina_subject)
            cocina_subject&.source&.code == 'fast'
          end
        end
      end
    end
  end
end
