# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates types for description against description_types.yml.
      class DescriptionTypesValidator
        def self.validate(clazz, attributes)
          new(clazz, attributes).validate
        end

        def initialize(clazz, attributes)
          @clazz = clazz
          @attributes = attributes
          @error_paths = []
        end

        def validate
          return unless meets_preconditions?

          validate_obj(attributes, [])

          return if error_paths.empty?

          raise ValidationError, "Unrecognized types in description: #{error_paths.join(', ')}"
        end

        private

        attr_reader :clazz, :attributes, :error_paths

        def meets_preconditions?
          [Cocina::Models::Description, Cocina::Models::RequestDescription].include?(clazz)
        end

        def validate_hash(hash, path)
          hash.each do |key, obj|
            if key == :type
              validate_type(obj, path)
            else
              validate_obj(obj, path + [key])
            end
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

        def validate_type(type, path)
          valid_types.each do |type_signature, types|
            next unless match?(path, type_signature)
            break if types.include?(type.downcase)

            error_paths << "#{path_to_s(path)} (#{type})"
            break
          end
        end

        def match?(path, type_signature)
          clean_path(path).last(type_signature.length) == type_signature
        end

        # Some part of the path are ignored for the purpose of matching.
        def clean_path(path)
          new_path = path.reject do |part|
            part.is_a?(Integer) || %i[parallelValue parallelEvent].include?(part)
          end
          # This needs to happen after parallelValue is removed
          # to handle structuredValue > parallelValue > structuredValue
          new_path.reject.with_index do |part, index|
            part == :structuredValue && new_path[index - 1] == :structuredValue
          end
        end

        # rubocop:disable Style/ClassVars
        def valid_types
          # Class var to minimize loading from disk.
          @@valid_types ||= begin
            types = types_yaml.map do |type_signature_str, type_objs|
              type_signature = type_signature_str.split('.').map(&:to_sym)
              types = type_objs.map { |type_obj| type_obj['value'].downcase }
              [type_signature, types]
            end
            # Sorting so that longer signatures match first.
            types.sort { |a, b| b.first.length <=> a.first.length }
          end
        end
        # rubocop:enable Style/ClassVars

        def types_yaml
          YAML.load_file(::File.expand_path('../../../../description_types.yml', __dir__))
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
