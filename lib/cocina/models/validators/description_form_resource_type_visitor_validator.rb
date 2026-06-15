# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates form.value against allowed values when form.source.value is a known controlled vocabulary.
      class DescriptionFormResourceTypeVisitorValidator < BaseDescriptionVisitorValidator
        def validate!
          return if error_paths.empty?

          raise ValidationError, "Unrecognized resource type values in description: #{error_paths.join(', ')}"
        end

        def visit_hash(hash:, path:)
          return unless form_entry_path?(path)
          return unless hash[:type].to_s == 'resource type'

          source_value = hash.dig(:source, :value)
          return unless source_value && valid_values_by_source.key?(source_value)

          value = hash[:value]
          return unless value
          return if valid_values_by_source[source_value].include?(value)

          error_paths << "#{path_to_s(path)} (#{value})"
        end

        private

        def error_paths
          @error_paths ||= []
        end

        def form_entry_path?(path)
          path.length >= 2 && path[-1].is_a?(Integer) && path[-2].to_s == 'form'
        end

        # rubocop:disable Style/ClassVars
        def valid_values_by_source
          @@valid_values_by_source ||= YAML.load_file(::File.expand_path('../../../../resource_type_values.yml', __dir__))
        end
        # rubocop:enable Style/ClassVars
      end
    end
  end
end
