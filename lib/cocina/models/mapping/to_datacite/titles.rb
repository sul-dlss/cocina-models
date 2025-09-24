# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module ToDatacite
        # Transform the Cocina::Models::Description title attributes to attributes for one DataCite title
        #  see https://support.datacite.org/reference/dois-2#put_dois-id
        class Titles
          # @param [Cocina::Models::Description] cocina_desc
          # @return [Array<Hash>] list of titles for DataCite, conforming to the expectations of HTTP PUT request
          # to DataCite
          def self.build(cocina_desc)
            new(cocina_desc).call
          end

          def initialize(cocina_desc)
            @cocina_desc = cocina_desc
          end

          # @return [Array<Hash>] list of titles for DataCite, conforming to the expectations of HTTP PUT request
          # to DataCite
          def call
            [{ title: cocina_desc.title.first.value }]
          end

          private

          attr_reader :cocina_desc
        end
      end
    end
  end
end
