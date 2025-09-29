# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module ToDatacite
        # Transform the Cocina::Models::Description title attributes to attributes for one DataCite title
        #  see https://support.datacite.org/reference/dois-2#put_dois-id
        class Titles
          # @param [Cocina::Models::Description] description
          # @return [Array<Hash>] list of titles for DataCite, conforming to the expectations of HTTP PUT request
          # to DataCite
          def self.build(...)
            new(...).call
          end

          def initialize(description:)
            @description = description
          end

          # @return [Array<Hash>] list of titles for DataCite, conforming to the expectations of HTTP PUT request
          # to DataCite
          def call
            [{ title: description.title.first.value }]
          end

          private

          attr_reader :description
        end
      end
    end
  end
end
