# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that there is only one of value, groupedValue, structuredValue, or parallelValue.
      class DescriptionValuesValidator
        def self.validate(clazz, attributes)
          new(clazz, attributes).validate
        end

        def initialize(clazz, attributes)
          @clazz = clazz
          @attributes = attributes
          @error_paths_multiple = []
          @error_paths_blank = []
          @error_paths_missing_title_type = []
        end

        def validate
          return unless meets_preconditions?

          validate_obj(attributes, [])

          raise ValidationError, "Multiple value, groupedValue, structuredValue, and parallelValue in description: #{error_paths_multiple.join(', ')}" unless error_paths_multiple.empty?
          raise ValidationError, "Blank value in description: #{error_paths_blank.join(', ')}" unless error_paths_blank.empty?
          raise ValidationError, "Missing type for value in description: #{error_paths_missing_title_type.join(', ')}" unless error_paths_missing_title_type.empty?
        end

        private

        attr_reader :clazz, :attributes, :error_paths_blank, :error_paths_multiple, :error_paths_missing_title_type

        def meets_preconditions?
          [Cocina::Models::Description, Cocina::Models::RequestDescription].include?(clazz)
        end

        def validate_hash(hash, path)
          validate_values_for_blanks(hash, path)
          validate_values_for_multiples(hash, path)
          validate_title_type(hash, path)
          hash.each do |key, obj|
            validate_obj(obj, path + [key])
          end
        end

        def validate_array(array, path)
          array.each_with_index do |obj, index|
            validate_obj(obj, path + [index])
          end
        end

        def validate_obj(obj, path)
          validate_hash(obj, path) if obj.is_a?(Hash)
          validate_array(obj, path) if obj.is_a?(Array)
        end

        def validate_values_for_blanks(hash, path)
          return unless hash[:value] && hash[:value].is_a?(String) && /\A\s+\z/.match?(hash[:value]) # rubocop:disable Style/SafeNavigation

          error_paths_blank << path_to_s(path)
        end

        def validate_values_for_multiples(hash, path)
          return unless hash.count { |key, value| %i[value groupedValue structuredValue parallelValue].include?(key) && value.present? } > 1

          error_paths_multiple << path_to_s(path)
        end

        def validate_title_type(hash, path)
          # only apply to title.structuredValue, title.parallelValue.structuredValue, or relatedResource.title with a value
          return unless hash[:value] && (path.first == :title || related_resource_title?(path)) && path.include?(:structuredValue)

          # if there is a "value" key, make sure there is also a "type" key, only for title.structuredValue
          error_paths_missing_title_type << path_to_s(path) unless hash[:type]
        end

        def related_resource_title?(path)
          # title is directly within relatedResource, e.g [:relatedResource, 0, :title, 0, :structuredValue, 0])
          path.first == :relatedResource && path[2] == :title
        end

        def path_to_s(path)
          # This matches the format used by descriptive spreadsheets
          path_str = ''
          path.each_with_index do |part, index|
            if part.is_a?(Integer)
              path_str += (part + 1).to_s
            else
              path_str += '.' if index.positive?
              path_str += part.to_s
            end
          end
          path_str
        end
      end
    end
  end
end
