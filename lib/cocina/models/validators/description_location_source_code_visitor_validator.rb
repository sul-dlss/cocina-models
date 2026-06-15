# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates location.source.code values against location_source_codes.yml.
      class DescriptionLocationSourceCodeVisitorValidator < BaseDescriptionVisitorValidator
        def validate!
          return if error_paths.empty?

          raise ValidationError, "Unrecognized location source codes in description: #{error_paths.join(', ')}"
        end

        def visit_hash(hash:, path:)
          return unless location_path?(path)

          source_code = hash.dig(:source, :code)
          return unless source_code
          return if valid_codes.include?(source_code.downcase)

          error_paths << "#{path_to_s(path)}.source.code (#{source_code})"
        end

        private

        def error_paths
          @error_paths ||= []
        end

        def location_path?(path)
          # Match entries in a location array (e.g., [:location, 0] or [:relatedResource, 0, :location, 0]).
          path.length >= 2 && path[-1].is_a?(Integer) && path[-2].to_s == 'location'
        end

        # rubocop:disable Style/ClassVars
        def valid_codes
          @@valid_codes ||= YAML.load_file(::File.expand_path('../../../../location_source_codes.yml', __dir__)).to_set(&:downcase)
        end
        # rubocop:enable Style/ClassVars
      end
    end
  end
end
