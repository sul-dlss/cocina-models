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

          errors = schema.ref("#/$defs/#{method_name}").validate(attributes.as_json).to_a
          return unless errors.any?

          raise ValidationError, "When validating #{method_name}: " + errors.map { |e| e['error'] }.uniq.join(', ')
        end

        # @return [Hash] a hash representation of the schema.json document
        def self.document
          @document ||= begin
            file_content = ::File.read(schema_path)
            JSON.parse(file_content)
          end
        end

        # @return [JSONSchemer::Schema]
        def self.schema
          @schema ||= JSONSchemer.schema(document)
        end
        private_class_method :schema

        def self.schema_path
          ::File.expand_path('../../../../schema.json', __dir__)
        end
        private_class_method :schema_path
      end
    end
  end
end
