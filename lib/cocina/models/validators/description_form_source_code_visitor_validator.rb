# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates form.source.code values against form_source_codes.yml.
      class DescriptionFormSourceCodeVisitorValidator < BaseDescriptionVisitorValidator
        def validate!
          return if error_paths.empty?

          raise ValidationError, "Unrecognized form source codes in description: #{error_paths.join(', ')}"
        end

        def visit_hash(hash:, path:)
          return unless form_entry_path?(path)

          source_code = hash.dig(:source, :code)
          return unless source_code

          error_paths << "#{path_to_s(path)}.source.code (#{source_code})" unless valid_codes.include?(source_code.downcase)
        end

        private

        def error_paths
          @error_paths ||= []
        end

        def form_entry_path?(path)
          path.length >= 2 && path[-1].is_a?(Integer) && path[-2].to_s == 'form'
        end

        # rubocop:disable Style/ClassVars
        def valid_codes
          @@valid_codes ||= YAML.load_file(::File.expand_path('../../../../form_source_codes.yml', __dir__)).to_set(&:downcase)
        end
        # rubocop:enable Style/ClassVars
      end
    end
  end
end
