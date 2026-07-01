# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates language.source.code and valueLanguage.source.code values against language_source_codes.yml.
      class DescriptionLanguageSourceCodeVisitorValidator < BaseDescriptionVisitorValidator
        def validate!
          return if error_paths.empty?

          raise ValidationError, "Unrecognized language source codes in description: #{error_paths.join(', ')}"
        end

        def visit_hash(hash:, path:)
          return unless language_or_value_language_path?(path)

          source_code = hash.dig(:source, :code)
          return unless source_code
          return if valid_codes.include?(source_code.downcase)

          error_paths << "#{path_to_s(path)}.source.code (#{source_code})"
        end

        private

        def error_paths
          @error_paths ||= []
        end

        def language_or_value_language_path?(path)
          language_path?(path) || value_language_path?(path)
        end

        def language_path?(path)
          # language is a typed array (Array.of(Language)), so the visitor descends through
          # an integer index. Path ends with [:language, <Integer>].
          path.length >= 2 && path[-1].is_a?(Integer) && path[-2].to_s == 'language'
        end

        def value_language_path?(path)
          # valueLanguage is a single optional hash (not an array), so the visitor descends
          # directly by key. Path ends with [:valueLanguage].
          path.length >= 1 && path[-1].to_s == 'valueLanguage'
        end

        # rubocop:disable Style/ClassVars
        def valid_codes
          @@valid_codes ||= YAML.load_file(::File.expand_path('../../../../language_source_codes.yml', __dir__)).to_set(&:downcase)
        end
        # rubocop:enable Style/ClassVars
      end
    end
  end
end
