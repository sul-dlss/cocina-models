# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Perform validation against openapi
      class OpenApiValidator
        def self.validate(clazz, attributes)
          return unless clazz.name

          method_name = clazz.name.split('::').last
          request_operation = root.request_operation(:post, "/validate/#{method_name}")

          # JSON.parse forces serialization of objects like DateTime.
          json_attributes = JSON.parse(attributes.to_json)
          # Inject cocinaVersion if needed and not present.
          if operation_has_cocina_version?(request_operation) && !json_attributes.include?('cocinaVersion')
            json_attributes['cocinaVersion'] = Cocina::Models::VERSION
          end

          request_operation.validate_request_body('application/json', json_attributes)
        rescue OpenAPIParser::OpenAPIError => e
          raise ValidationError, e.message
        end

        def self.operation_has_cocina_version?(request_operation)
          schema = request_operation.operation_object.request_body.content['application/json'].schema
          all_of_properties = Array(schema.all_of&.flat_map { |all_of| all_of.properties&.keys }).compact
          one_of_properties = Array(schema.one_of&.flat_map { |one_of| one_of.properties&.keys }).compact
          properties = Array(schema.properties&.keys)
          (properties + all_of_properties + one_of_properties).include?('cocinaVersion')
        end
        private_class_method :operation_has_cocina_version?

        # rubocop:disable Style/ClassVars
        def self.root
          @@root ||= OpenAPIParser.parse(YAML.load_file(openapi_path), strict_reference_validation: true)
        end
        # rubocop:enable Style/ClassVars
        private_class_method :root

        def self.openapi_path
          ::File.expand_path('../../../../openapi.yml', __dir__)
        end
        private_class_method :openapi_path
      end
    end
  end
end
