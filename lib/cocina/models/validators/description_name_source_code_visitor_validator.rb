# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates contributor.name.source.code values against name_source_codes.yml.
      class DescriptionNameSourceCodeVisitorValidator < BaseDescriptionVisitorValidator
        def validate!
          return if error_paths.empty?

          raise ValidationError, "Unrecognized name source codes in description: #{error_paths.join(', ')}"
        end

        def visit_hash(hash:, path:)
          return unless name_path?(path)

          source_code = hash.dig(:source, :code)
          return unless source_code
          return if valid_codes.include?(source_code.downcase)

          error_paths << "#{path_to_s(path)}.source.code (#{source_code})"
        end

        private

        def error_paths
          @error_paths ||= []
        end

        def name_path?(path)
          path.length >= 2 &&
            path[-1].is_a?(Integer) &&
            path[-2].to_s == 'name' &&
            path.any? { |part| part.to_s == 'contributor' }
        end

        # rubocop:disable Style/ClassVars
        def valid_codes
          @@valid_codes ||= YAML.load_file(::File.expand_path('../../../../name_source_codes.yml', __dir__)).to_set(&:downcase)
        end
        # rubocop:enable Style/ClassVars
      end
    end
  end
end
