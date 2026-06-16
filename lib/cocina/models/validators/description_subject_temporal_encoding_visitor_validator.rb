# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates encoding.code for subject entries with type "time" against
      # temporal_subject_encoding_codes.yml (union of LOC date-time and temporal source lists).
      class DescriptionSubjectTemporalEncodingVisitorValidator < BaseDescriptionVisitorValidator
        def validate!
          return if error_paths.empty?

          raise ValidationError, "Unrecognized subject temporal encoding codes in description: #{error_paths.join(', ')}"
        end

        def visit_hash(hash:, path:)
          return unless in_subject_path?(path)
          return unless hash[:type].to_s == 'time'

          encoding_code = hash.dig(:encoding, :code)
          return unless encoding_code

          error_paths << "#{path_to_s(path)}.encoding.code (#{encoding_code})" unless valid_codes.include?(encoding_code.downcase)
        end

        private

        def error_paths
          @error_paths ||= []
        end

        def in_subject_path?(path)
          path.any? { |part| part.to_s == 'subject' }
        end

        # rubocop:disable Style/ClassVars
        def valid_codes
          @@valid_codes ||= YAML.load_file(::File.expand_path('../../../../temporal_subject_encoding_codes.yml', __dir__)).to_set(&:downcase)
        end
        # rubocop:enable Style/ClassVars
      end
    end
  end
end
