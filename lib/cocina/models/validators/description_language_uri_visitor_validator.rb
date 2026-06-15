# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates language.uri and valueLanguage.uri against LC ISO 639-2, LC MARC languages,
      # and 5 approved ISO 639-3 URIs. Both http and https are acceptable.
      class DescriptionLanguageUriVisitorValidator < BaseDescriptionVisitorValidator
        ISO639_3_CODES = %w[ase dnt quc skr trw tta].freeze

        def visit_hash(hash:, path:)
          return unless language_or_value_language_path?(path)

          uri = hash[:uri]
          return unless uri

          error_paths << "#{path_to_s(path)}.uri (#{uri})" unless valid_uri?(uri)
        end

        def validate!
          return if error_paths.empty?

          raise ValidationError, "Invalid language URIs in description: #{error_paths.join(', ')}"
        end

        private

        def error_paths
          @error_paths ||= []
        end

        def language_or_value_language_path?(path)
          language_path?(path) || value_language_path?(path)
        end

        def language_path?(path)
          path.length >= 2 && path[-1].is_a?(Integer) && path[-2].to_s == 'language'
        end

        def value_language_path?(path)
          path.length >= 1 && path[-1].to_s == 'valueLanguage'
        end

        def valid_uri?(uri)
          normalized = uri.sub(%r{\Ahttps?://}, '')
          valid_iso639_2_uri?(normalized) || valid_iso639_3_uri?(normalized) || valid_languages_uri?(normalized)
        end

        def valid_iso639_2_uri?(normalized)
          match = normalized.match(%r{\Aid\.loc\.gov/vocabulary/iso639-2/(.+)\z})
          return false unless match

          valid_iso639_2_codes.include?(match[1].downcase)
        end

        def valid_iso639_3_uri?(normalized)
          match = normalized.match(%r{\Aid\.loc\.gov/vocabulary/iso639-3/(.+)\z})
          return false unless match

          ISO639_3_CODES.include?(match[1].downcase)
        end

        def valid_languages_uri?(normalized)
          match = normalized.match(%r{\Aid\.loc\.gov/vocabulary/languages/(.+)\z})
          return false unless match

          valid_languages_codes.include?(match[1].downcase)
        end

        # rubocop:disable Style/ClassVars
        def valid_iso639_2_codes
          @@valid_iso639_2_codes ||= YAML.load_file(
            ::File.expand_path('../../../../language_uri_iso639_2_codes.yml', __dir__)
          ).to_set(&:downcase)
        end

        def valid_languages_codes
          @@valid_languages_codes ||= YAML.load_file(
            ::File.expand_path('../../../../language_uri_languages_codes.yml', __dir__)
          ).to_set(&:downcase)
        end
        # rubocop:enable Style/ClassVars
      end
    end
  end
end
