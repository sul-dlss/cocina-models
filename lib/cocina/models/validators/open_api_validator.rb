# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Perform validation against openapi
      class OpenApiValidator
        def self.validate(clazz, attributes)
          return unless clazz.name

          method_name = clazz.name.split('::').last

          if %w[DRO RequestDRO AdminPolicy RequestAdminPolicy Collection RequestCollection DROWithMetadata].include? method_name
            attributes['cocinaVersion'] = Cocina::Models::VERSION
          end

          errors = document.ref("#/components/schemas/#{method_name}").validate(attributes.as_json).to_a
          return unless errors.any?

          raise ValidationError, "When validating #{method_name}: " + errors.map { |e| e['error'] }.uniq.join(', ')
        end

        # rubocop:disable Style/ClassVars
        def self.document
          @@document ||= JSONSchemer.openapi(YAML.load_file(openapi_path))
        end
        # rubocop:enable Style/ClassVars
        private_class_method :document

        def self.openapi_path
          ::File.expand_path('../../../../openapi.yml', __dir__)
        end
        private_class_method :openapi_path
      end
    end
  end
end
