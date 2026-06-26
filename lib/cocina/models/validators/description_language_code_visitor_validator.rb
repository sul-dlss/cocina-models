# frozen_string_literal: true

require 'cocina_display'

module Cocina
  module Models
    module Validators
      # Validates language.code values against searchworks_languages from cocina_display gem plus mul, und, zxx.
      class DescriptionLanguageCodeVisitorValidator < BaseDescriptionVisitorValidator
        EXTRA_VALID_CODES = %w[mul und zxx].freeze

        def validate!
          return if error_paths.empty?

          raise ValidationError, "Unrecognized language codes in description: #{error_paths.join(', ')}"
        end

        def visit_hash(hash:, path:)
          return unless language_path?(path)

          code = hash[:code]
          return unless code

          error_paths << "#{path_to_s(path)}.code (#{code})" unless valid_codes.include?(code)
        end

        private

        def error_paths
          @error_paths ||= []
        end

        def language_path?(path)
          path.length >= 2 && path[-1].is_a?(Integer) && path[-2].to_s == 'language'
        end

        # rubocop:disable Style/ClassVars
        def valid_codes
          @@valid_codes ||= begin
            gem_codes = CocinaDisplay::Languages::Language.searchworks_languages.keys.to_set
            gem_codes.merge(EXTRA_VALID_CODES)
          end
        end
        # rubocop:enable Style/ClassVars
      end
    end
  end
end
