# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module ToDatacite
        # Maps description resource from cocina to DataCite JSON
        class AlternateIdentifiers
          # @param [Cocina::Models::Identification] identification
          def self.build(...)
            new(...).call
          end

          def initialize(description:)
            @description = description
          end

          attr_reader :description

          delegate :purl, to: :description

          def call
            [{
              alternateIdentifier: purl,
              alternateIdentifierType: 'PURL'
            }]
          end
        end
      end
    end
  end
end
