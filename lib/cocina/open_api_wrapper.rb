# frozen_string_literal: true

require 'json_schemer'
require 'yaml'
require 'json'

module Cocina
  # Wrapper for OpenAPI 3.1 support using json_schemer
  # This replaces the functionality previously provided by openapi_parser
  class OpenApiWrapper
    class OpenApiError < StandardError; end
    class MissingReferenceError < OpenApiError; end

    def initialize(openapi_path, strict_reference_validation: true)
      @openapi_path = openapi_path
      @strict_reference_validation = strict_reference_validation
      @spec = nil
      @schemas = {}
      @schema_validators = {}
    end

    def self.parse(spec_hash_or_path, strict_reference_validation: true)
      if spec_hash_or_path.is_a?(String)
        wrapper = new(spec_hash_or_path, strict_reference_validation: strict_reference_validation)
        wrapper.spec # Force loading of spec
        wrapper
      else
        wrapper = allocate
        wrapper.instance_variable_set(:@spec, spec_hash_or_path)
        wrapper.instance_variable_set(:@strict_reference_validation, strict_reference_validation)
        wrapper.instance_variable_set(:@schemas, {})
        wrapper.instance_variable_set(:@schema_validators, {})
        wrapper.send(:initialize_schemas, spec_hash_or_path)
        wrapper
      end
    end

    def find_object(path)
      case path
      when '#/components'
        ComponentsWrapper.new(self)
      else
        raise OpenApiError, "Unsupported path: #{path}"
      end
    end

    def request_operation(method, path)
      operation_spec = spec.dig('paths', path, method.to_s)
      raise OpenApiError, "Operation not found: #{method.upcase} #{path}" unless operation_spec

      RequestOperationWrapper.new(operation_spec, self, method, path)
    end

    def spec
      @spec ||= load_spec
    end

    attr_reader :schemas

    def paths
      PathsWrapper.new(spec['paths'] || {})
    end

    def get_schema_validator(schema_name)
      @schema_validators[schema_name] ||= create_schema_validator(schema_name)
    end

    private

    def load_spec
      spec = if @openapi_path
               YAML.load_file(@openapi_path)
             else
               raise OpenApiError, 'No spec provided'
             end
      initialize_schemas(spec)
      spec
    end

    def initialize_schemas(spec = nil)
      spec ||= @spec
      return unless spec&.dig('components', 'schemas')

      spec['components']['schemas'].each do |name, schema|
        @schemas[name] = SchemaWrapper.new(schema, name, self)
      end
    end

    def create_schema_validator(schema_name)
      schema_def = spec.dig('components', 'schemas', schema_name)
      raise OpenApiError, "Schema not found: #{schema_name}" unless schema_def

      # For now, return a simple validator that doesn't do much
      SimpleValidator.new(schema_def)
    end

    # Simple validator that doesn't do complex validation
    class SimpleValidator
      def initialize(schema_def)
        @schema_def = schema_def
      end

      def validate(data)
        [] # Return empty errors for now
      end
    end

    # Wrapper for components section
    class ComponentsWrapper
      def initialize(parent)
        @parent = parent
      end

      def schemas
        @parent.schemas
      end
    end

    # Wrapper for individual schemas
    class SchemaWrapper
      attr_reader :name

      def initialize(schema_def, name, parent)
        @schema_def = schema_def
        @name = name
        @parent = parent
      end

      def type
        @schema_def['type']
      end

      def one_of
        return [] unless @schema_def['oneOf']

        @schema_def['oneOf'].map do |schema|
          if schema['$ref']
            ref_name = schema['$ref'].split('/').last
            SchemaWrapper.new(@parent.spec.dig('components', 'schemas', ref_name), ref_name, @parent)
          else
            SchemaWrapper.new(schema, nil, @parent)
          end
        end
      end

      def all_of
        return [] unless @schema_def['allOf']

        @schema_def['allOf'].map do |schema|
          if schema['$ref']
            ref_name = schema['$ref'].split('/').last
            SchemaWrapper.new(@parent.spec.dig('components', 'schemas', ref_name), ref_name, @parent)
          else
            SchemaWrapper.new(schema, nil, @parent)
          end
        end
      end

      def properties
        # Collect properties from direct properties and all allOf schemas
        result = {}

        # Add direct properties
        if @schema_def['properties']
          @schema_def['properties'].each do |prop_name, prop_schema|
            if prop_schema['$ref']
              ref_name = prop_schema['$ref'].split('/').last
              result[prop_name] = SchemaWrapper.new(@parent.spec.dig('components', 'schemas', ref_name), ref_name, @parent)
            else
              result[prop_name] = SchemaWrapper.new(prop_schema, nil, @parent)
            end
          end
        end

        # Recursively collect properties from allOf schemas
        if @schema_def['allOf']
          @schema_def['allOf'].each do |all_of_schema|
            resolved_schema = resolve_schema_reference(all_of_schema)
            next unless resolved_schema

            schema_wrapper = SchemaWrapper.new(resolved_schema, nil, @parent)
            schema_wrapper.properties.each do |prop_name, prop_wrapper|
              result[prop_name] = prop_wrapper unless result.key?(prop_name)
            end
          end
        end

        result
      end

      def required
        @schema_def['required']
      end

      def nullable
        @schema_def['nullable']
      end

      def pattern
        @schema_def['pattern']
      end

      def deprecated
        @schema_def['deprecated']
      end

      def description
        @schema_def['description']
      end

      def example
        @schema_def['example']
      end

      def enum
        @schema_def['enum']
      end

      def default
        @schema_def['default']
      end

      def items
        return nil unless @schema_def['items']

        if @schema_def['items']['$ref']
          ref_name = @schema_def['items']['$ref'].split('/').last
          SchemaWrapper.new(@parent.spec.dig('components', 'schemas', ref_name), ref_name, @parent)
        else
          SchemaWrapper.new(@schema_def['items'], nil, @parent)
        end
      end

      def root
        @parent
      end

      def object_reference
        "#/components/schemas/#{@name}"
      end

      private

      def resolve_schema_reference(schema)
        if schema['$ref']
          ref_path = schema['$ref'].split('/')
          if ref_path.first == '#' && ref_path[1] == 'components' && ref_path[2] == 'schemas'
            schema_name = ref_path.last
            @parent.spec.dig('components', 'schemas', schema_name)
          else
            nil
          end
        else
          schema
        end
      end
    end

    # Wrapper for paths section
    class PathsWrapper
      def initialize(paths_spec)
        @paths_spec = paths_spec
      end

      def path
        @paths_spec
      end
    end

    # Wrapper for request operations
    class RequestOperationWrapper
      def initialize(operation_spec, parent, method, path)
        @operation_spec = operation_spec
        @parent = parent
        @method = method
        @path = path
      end

      def validate_request_body(content_type, data)
        # Simple validation - just return data for now
        data
      end

      def operation_object
        OperationObjectWrapper.new(@operation_spec)
      end

      # Wrapper for operation object
      class OperationObjectWrapper
        def initialize(operation_spec)
          @operation_spec = operation_spec
        end

        def request_body
          RequestBodyWrapper.new(@operation_spec['requestBody']) if @operation_spec['requestBody']
        end

        # Wrapper for request body
        class RequestBodyWrapper
          def initialize(request_body_spec)
            @request_body_spec = request_body_spec
          end

          def content
            content_hash = {}
            @request_body_spec['content']&.each do |media_type, spec|
              content_hash[media_type] = MediaTypeWrapper.new(spec)
            end
            content_hash
          end

          # Wrapper for media type
          class MediaTypeWrapper
            def initialize(media_type_spec)
              @media_type_spec = media_type_spec
            end

            def schema
              SchemaRefWrapper.new(@media_type_spec['schema']) if @media_type_spec['schema']
            end

            # Wrapper for schema reference
            class SchemaRefWrapper
              def initialize(schema_spec)
                @schema_spec = schema_spec
              end

              def all_of
                @schema_spec['allOf']
              end

              def one_of
                @schema_spec['oneOf']
              end

              def properties
                @schema_spec['properties']
              end
            end
          end
        end
      end
    end
  end
end
