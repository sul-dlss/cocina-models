# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that there is only one of value, groupedValue, structuredValue, or parallelValue,
      # that values are not blank, and that title structuredValue entries have a type.
      class DescriptionValuesVisitorValidator < BaseDescriptionVisitorValidator
        def visit_hash(hash:, path:)
          validate_values_for_blanks(hash, path)
          validate_values_for_multiples(hash, path)
          validate_title_type(hash, path)
        end

        def validate!
          unless error_paths_multiple.empty?
            raise ValidationError,
                  "Multiple value, groupedValue, structuredValue, and parallelValue in description: #{error_paths_multiple.join(', ')}"
          end
          unless error_paths_blank.empty?
            raise ValidationError,
                  "Blank value in description: #{error_paths_blank.join(', ')}"
          end
          return if error_paths_missing_title_type.empty?

          raise ValidationError,
                "Missing type for value in description: #{error_paths_missing_title_type.join(', ')}"
        end

        private

        def error_paths_multiple
          @error_paths_multiple ||= []
        end

        def error_paths_blank
          @error_paths_blank ||= []
        end

        def error_paths_missing_title_type
          @error_paths_missing_title_type ||= []
        end

        def validate_values_for_blanks(hash, path)
          return unless hash[:value] && hash[:value].is_a?(String) && /\A\s+\z/.match?(hash[:value]) # rubocop:disable Style/SafeNavigation

          error_paths_blank << path_to_s(path)
        end

        def validate_values_for_multiples(hash, path)
          return unless hash.count do |key, value|
            %w[value groupedValue structuredValue parallelValue].include?(key) && value.present?
          end > 1

          error_paths_multiple << path_to_s(path)
        end

        def validate_title_type(hash, path)
          # only apply to title.structuredValue, title.parallelValue.structuredValue, or relatedResource.title with a value
          return unless hash[:value] && (structured_value_title?(path) || related_resource_title?(path))

          # if there is a "value" key, make sure there is also a "type" key, only for title.structuredValue
          error_paths_missing_title_type << path_to_s(path) unless hash[:type]
        end

        def related_resource_title?(path)
          # title is within relatedResource, e.g ["relatedResource", 0, "title", 0, "structuredValue", 0])
          structured_value_path = path[4] == 'structuredValue' || (path[4] == 'parallelValue' && path[6] == 'structuredValue')
          path.first == 'relatedResource' && path[2] == 'title' && structured_value_path
        end

        def structured_value_title?(path)
          # title path includes a structuredValue directly or within a parallelValue
          # e.g. ["title", 0, "structuredValue", 0] or ["title", 0, "parallelValue", 0, "structuredValue", 0])
          structured_value_path = path[2] == 'structuredValue' || (path[2] == 'parallelValue' && path[4] == 'structuredValue')
          path.first == 'title' && structured_value_path
        end
      end
    end
  end
end
