# frozen_string_literal: true

module Cocina
  module Models
    # Perform validation against openapi
    class Validator
      def self.validate(clazz, attributes)
        method_name = clazz.name.split('::').last
        request_operation = root.request_operation(:post, "/validate/#{method_name}")
        request_operation.validate_request_body('application/json', attributes)
      rescue OpenAPIParser::OpenAPIError => e
        raise ValidationError, e.message
      end

      # rubocop:disable Style/ClassVars
      def self.root
        @@root ||= OpenAPIParser.parse(YAML.load_file(openapi_path))
      end
      # rubocop:enable Style/ClassVars
      private_class_method :root

      def self.openapi_path
        ::File.expand_path('../../../openapi.yml', __dir__)
      end
      private_class_method :openapi_path
    end
  end
end
