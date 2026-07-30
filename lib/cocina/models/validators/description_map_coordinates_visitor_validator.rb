# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates map coordinate values using the visitor pattern.
      class DescriptionMapCoordinatesVisitorValidator < BaseDescriptionVisitorValidator
        STRUCTURED_COORDINATE_TYPES = ['bounding box coordinates', 'point coordinates'].freeze

        def visit_hash(hash:, path:)
          case hash[:type]
          when 'map coordinates'
            check_range(hash, path)
          when *STRUCTURED_COORDINATE_TYPES
            check_structured_coordinates(hash, path)
          end
        end

        def validate!
          return if error_paths.empty?

          raise ValidationError, "Invalid map coordinates in description: #{error_paths.join(', ')}"
        end

        private

        def error_paths
          @error_paths ||= []
        end

        def check_range(hash, path)
          value = hash[:value]
          return unless value.is_a?(String)

          error_paths << path_to_s(path) unless MapCoordinatesValidator.valid_range?(value)
        end

        def check_structured_coordinates(hash, path)
          Array(hash[:structuredValue]).each_with_index do |structured_value, index|
            value = structured_value[:value]
            next unless value.is_a?(String)

            error_paths << path_to_s(path + [:structuredValue, index]) unless MapCoordinatesValidator.valid_coordinate?(value)
          end
        end
      end
    end
  end
end
