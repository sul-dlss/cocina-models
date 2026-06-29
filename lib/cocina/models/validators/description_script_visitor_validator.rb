# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates language.script and valueLanguage.valueScript:
      #   - source.code, when present, must be 'iso15924' (case-insensitive)
      #   - code must be a recognized ISO 15924 script code (when source.code is 'iso15924')
      class DescriptionScriptVisitorValidator < BaseDescriptionVisitorValidator
        def validate!
          raise ValidationError, "Unrecognized script source codes in description: #{source_error_paths.join(', ')}" if source_error_paths.any?
          raise ValidationError, "Unrecognized script codes in description: #{error_paths.join(', ')}" if error_paths.any?
        end

        def visit_hash(hash:, path:)
          if language_path?(path)
            validate_script(hash, path, :script)
          elsif value_language_path?(path)
            validate_script(hash, path, :valueScript)
          end
        end

        private

        def error_paths
          @error_paths ||= []
        end

        def source_error_paths
          @source_error_paths ||= []
        end

        # Matches entries in a language array (e.g., [:language, 0] or [:adminMetadata, :language, 0]).
        # Since language is an array of objects, the last element is the integer index
        # and the second-to-last is the key 'language'.
        def language_path?(path)
          path.length >= 2 && path[-1].is_a?(Integer) && path[-2].to_s == 'language'
        end

        # Matches single valueLanguage objects (e.g., [:title, 0, :valueLanguage]).
        # Since valueLanguage is a single object rather than an array, the path ends
        # directly with 'valueLanguage'.
        def value_language_path?(path)
          path.present? && path[-1].to_s == 'valueLanguage'
        end

        def validate_script(hash, path, key)
          script = hash[key]
          return unless script

          source_code = script.dig(:source, :code)
          return unless source_code

          unless source_code.downcase == 'iso15924'
            source_error_paths << "#{path_to_s(path)}.#{key}.source.code (#{source_code})"
            return
          end

          code = script[:code]
          return unless code
          return if valid_script_codes.include?(code.downcase)

          error_paths << "#{path_to_s(path)}.#{key}.code (#{code})"
        end

        # rubocop:disable Style/ClassVars
        def valid_script_codes
          @@valid_script_codes ||= YAML.load_file(::File.expand_path('../../../../iso15924_codes.yml', __dir__)).to_set
        end
        # rubocop:enable Style/ClassVars
      end
    end
  end
end
