# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Perform validation against JSON schema
      class JsonSchemaValidator
        def self.validate(clazz, attributes)
          return unless clazz.name

          method_name = clazz.name.split('::').last

          attributes['cocinaVersion'] = Cocina::Models::VERSION if %w[DRO RequestDRO AdminPolicy RequestAdminPolicy Collection RequestCollection DROWithMetadata].include? method_name

          errors = openapi.ref("#/components/schemas/#{method_name}").validate(attributes.as_json).to_a
          return unless errors.any?

          raise ValidationError, "When validating #{method_name}: " + errors.map { |e| e['error'] }.uniq.join(', ')
        end

        # @return [Hash] a hash representation of the openapi document
        def self.document
          @document ||= YAML.load_file(openapi_path)
        end

        # @return [JSONSchemer::OpenAPI]
        def self.openapi
          @openapi ||= JSONSchemer.openapi(YAML.load_file(openapi_path))
        end
        private_class_method :openapi

        def self.openapi_path
          ::File.expand_path('../../../../openapi.yml', __dir__)
        end
        private_class_method :openapi_path
      end
    end
  end
end
