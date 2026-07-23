# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates types for description against description_types.yml.
      class DescriptionTypesVisitorValidator < BaseDescriptionVisitorValidator
        def validate!
          return if error_paths.empty?

          raise ValidationError, "Unrecognized types in description: #{error_paths.join(', ')}"
        end

        def visit_hash(hash:, path:)
          type = hash[:type]
          validate_type(type, path) if type
        end

        private

        def error_paths
          @error_paths ||= []
        end

        def validate_type(type, path)
          clean_path = clean_path(path)
          valid_types.each do |type_signature, types|
            next unless match?(clean_path, type_signature)

            break if types.include?(type.downcase)

            error_paths << "#{path_to_s(path)} (#{type})"
            break
          end
        end

        def match?(clean_path, type_signature)
          clean_path.last(type_signature.length) == type_signature
        end

        # Some part of the path are ignored for the purpose of matching.
        def clean_path(path)
          new_path = path.reject do |part|
            part.is_a?(Integer) || %i[parallelValue].include?(part.to_sym)
          end.map(&:to_sym)
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
      end
    end
  end
end
