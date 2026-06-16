# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that language.script.source.code and valueLanguage.valueScript.source.code
      # have the value 'iso15924'.
      class DescriptionScriptSourceCodeVisitorValidator < BaseDescriptionVisitorValidator
        def validate!
          return if error_paths.empty?

          raise ValidationError, "Unrecognized script source codes in description: #{error_paths.join(', ')}"
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

          source = script[:source]
          return unless source

          code = source[:code]
          return unless code
          return if valid_codes.include? code.downcase

          error_paths << "#{path_to_s(path)}.#{key}.source.code (#{code})"
        end

        def valid_codes
          %w[iso15924]
        end
      end
    end
  end
end
