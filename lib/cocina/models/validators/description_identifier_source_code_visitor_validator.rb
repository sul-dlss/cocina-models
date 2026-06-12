# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates identifier.source.code values against identifier_source_codes.yml.
      class DescriptionIdentifierSourceCodeVisitorValidator < BaseDescriptionVisitorValidator
        def validate!
          return if error_paths.empty?

          raise ValidationError, "Unrecognized identifier source codes in description: #{error_paths.join(', ')}"
        end

        def visit_hash(hash:, path:)
          return unless identifier_path?(path)

          source_code = hash.dig(:source, :code)
          return unless source_code

          error_paths << "#{path_to_s(path)}.source.code (#{source_code})" unless valid_codes.include?(source_code.downcase)
        end

        private

        def error_paths
          @error_paths ||= []
        end

        def identifier_path?(path)
          path.length >= 2 && path[-1].is_a?(Integer) && path[-2].to_s == 'identifier'
        end

        # rubocop:disable Style/ClassVars
        def valid_codes
          @@valid_codes ||= YAML.load_file(::File.expand_path('../../../../identifier_source_codes.yml', __dir__)).to_set(&:downcase)
        end
        # rubocop:enable Style/ClassVars
      end
    end
  end
end
