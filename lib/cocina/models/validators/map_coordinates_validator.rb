# frozen_string_literal: true

require 'stanford-mods'

module Cocina
  module Models
    module Validators
      # Validates that geospatial coordinates are parseable in DMS or decimal degrees form
      class MapCoordinatesValidator
        attr_reader :clazz, :attributes

        def self.validate(clazz, attributes)
          new(clazz, attributes).validate
        end

        def initialize(clazz, attributes)
          @clazz = clazz
          @attributes = attributes
        end

        # Valid if all coordinates are valid, or there are no coordinates
        def validate
          coordinates_values.each(&method(:validate_coordinates))
        end

        private

        def druid
          @druid ||= attributes[:externalIdentifier]
        end

        # Values of all non-empty 'subject' elements with type 'map coordinates'
        def coordinates_values
          @coordinates_values ||= Array(attributes.dig(:description, :subject))
                                  .select { |subject| subject[:type] == 'map coordinates' }
                                  .map { |subject| subject[:value] }
        end

        def validate_coordinates(coordinates)
          raise ValidationError, "Missing map coordinates for #{druid}" if coordinates.blank?
          raise ValidationError, "Invalid map coordinates for #{druid}: #{coordinates}" unless Stanford::Mods::Coordinate.new(coordinates).valid?
        end
      end
    end
  end
end
