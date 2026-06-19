# frozen_string_literal: true

require 'cocina_display'

module Cocina
  module Models
    module Validators
      # Validates location.source.code against location_source_codes.yml and
      # validates location.code against marc_country_codes.yml when source.code is marccountry.
      class DescriptionLocationVisitorValidator < BaseDescriptionVisitorValidator
        def validate!
          errors = []
          errors << "Unrecognized location source codes in description: #{error_paths.join(', ')}" if error_paths.any?
          errors << "Invalid MARC country codes in description: #{marc_country_error_paths.join(', ')}" if marc_country_error_paths.any?
          raise ValidationError, errors.join('; ') if errors.any?
        end

        def visit_hash(hash:, path:)
          return unless location_path?(path)

          source_code = hash.dig(:source, :code)
          return unless source_code

          error_paths << "#{path_to_s(path)}.source.code (#{source_code})" unless valid_codes.include?(source_code.downcase)

          return unless source_code.downcase == 'marccountry'

          code = hash[:code]
          marc_country_error_paths << "#{path_to_s(path)}.code (#{code})" if code && !valid_marc_country_codes.include?(code.downcase)
        end

        private

        def error_paths
          @error_paths ||= []
        end

        def marc_country_error_paths
          @marc_country_error_paths ||= []
        end

        def location_path?(path)
          # Match entries in a location array (e.g., [:location, 0] or [:relatedResource, 0, :location, 0]).
          path.length >= 2 && path[-1].is_a?(Integer) && path[-2].to_s == 'location'
        end

        # rubocop:disable Style/ClassVars
        def valid_codes
          @@valid_codes ||= YAML.load_file(::File.expand_path('../../../../location_source_codes.yml', __dir__)).to_set(&:downcase)
        end

        def valid_marc_country_codes
          @@valid_marc_country_codes ||= YAML.load_file(CocinaDisplay.root.join('config/marc_countries.yml')).keys.to_set(&:to_s)
        end
        # rubocop:enable Style/ClassVars
      end
    end
  end
end
