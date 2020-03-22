# frozen_string_literal: true

module Cocina
  module Models
    # Perform validation against openapi
    class Validator
      # rubocop:disable Style/ClassVars
      def self.root
        @@root ||=  OpenAPIParser.parse(YAML.load_file('openapi.yml'))
      end
      # rubocop:enable Style/ClassVars

      def self.validate(clazz, attributes)
        method_name = clazz.name.split('::').last
        request_operation = root.request_operation(:post, "/validate/#{method_name}")
        request_operation.validate_request_body('application/json', attributes)
      rescue OpenAPIParser::OpenAPIError => e
        raise ValidationError, e.message
      end
    end
  end
end
