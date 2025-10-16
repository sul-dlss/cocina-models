# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module ToDatacite
        # Transform the Cocina::Models::Description form attributes to the DataCite types attributes
        #  see https://support.datacite.org/reference/dois-2#put_dois-id
        class Types
          # @param [Cocina::Models::Description] description
          # @return [NilClass, Hash] the DataCite types attributes, conforming to the expectations of HTTP PUT request
          # to DataCite
          def self.build(...)
            new(...).call
          end

          def initialize(description:)
            @description = description
          end

          # @return [NilClass, Hash] the DataCite types attributes, conforming to the expectations of HTTP PUT request
          # to DataCite
          def call
            return unless resource_type_general || resource_type

            {
              resourceTypeGeneral: resource_type_general,
              resourceType: resource_type || ''
            }
          end

          private

          attr_reader :description

          # @return String DataCite resourceTypeGeneral value
          def resource_type_general
            @resource_type_general ||= Array(description.form).find do |cocina_form|
              datacite_resource_types_form?(cocina_form)
            end&.value
          end

          # @return [String] DataCite resourceType value
          def resource_type
            @resource_type ||= begin
              self_deposit_form = Array(description.form).find { |cocina_form| self_deposit_form?(cocina_form) }

              subtypes = self_deposit_subtypes(self_deposit_form)
              if subtypes.blank?
                self_deposit_type(self_deposit_form)
              else
                subtypes.select { |subtype| subtype if subtype != resource_type_general }.join('; ')
              end
            end
          end

          # call with cocina form element for Stanford self deposit resource types
          # @return String the value from the structuredValue when the type is 'type' for the cocina form element
          def self_deposit_type(cocina_self_deposit_form)
            cocina_self_deposit_form&.structuredValue&.each do |struct_val|
              return struct_val.value if struct_val.type == 'type'
            end
          end

          def self_deposit_subtypes(cocina_self_deposit_form)
            cocina_self_deposit_form&.structuredValue&.filter_map do |struct_val|
              struct_val.value if struct_val.type == 'subtype'
            end
          end

          def self_deposit_form?(cocina_form)
            cocina_form.type == 'resource type' &&
              cocina_form.source&.value == 'Stanford self-deposit resource types'
          end

          def datacite_resource_types_form?(cocina_form)
            cocina_form.source&.value == 'DataCite resource types'
          end
        end
      end
    end
  end
end
