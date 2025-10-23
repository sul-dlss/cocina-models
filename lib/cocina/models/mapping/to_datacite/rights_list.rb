# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module ToDatacite
        # Transform the Cocina::Models::DROAccess attributes to the DataCite rightsList attributes
        #  see https://support.datacite.org/reference/dois-2#put_dois-id
        class RightsList
          # @param [Cocina::Models::DROAccess] cocina_item_access
          # @return [NilClass,Array<Hash>] list of DataCite rightsList attributes, conforming to the expectations of
          # HTTP PUT request to DataCite
          def self.build(...)
            new(...).call
          end

          def initialize(access:)
            @access = access
          end

          # @return [NilClass,Array<Hash>] list of DataCite rightsList attributes, conforming to the expectations of
          # HTTP PUT request to DataCite
          def call
            return if access&.license.blank?

            [{
              rightsUri: access&.license
            }]
          end

          private

          attr_reader :access
        end
      end
    end
  end
end
