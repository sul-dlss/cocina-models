# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that event date structuredValue entries with a type also have a value.
      class DescriptionEventDateVisitorValidator < BaseDescriptionVisitorValidator
        def visit_hash(hash:, path:)
          return unless hash[:type] && !hash[:value]
          return unless event_date_structured_value?(path)

          error_paths << path_to_s(path)
        end

        def validate!
          return if error_paths.empty?

          raise ValidationError,
                "Missing value for type in description: #{error_paths.join(', ')}"
        end

        private

        def error_paths
          @error_paths ||= []
        end

        def event_date_structured_value?(path)
          return false unless path[0] == 'event' && path[2] == 'date'

          # Direct: event.date.structuredValue, e.g. ["event", 0, "date", 0, "structuredValue", 0]
          # Via parallelValue: event.date.parallelValue.structuredValue, e.g. ["event", 0, "date", 0, "parallelValue", 0, "structuredValue", 0]
          path[4] == 'structuredValue' || (path[4] == 'parallelValue' && path[6] == 'structuredValue')
        end
      end
    end
  end
end
