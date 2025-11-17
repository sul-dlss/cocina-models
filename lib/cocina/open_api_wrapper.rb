# frozen_string_literal: true

module Cocina
  # Wrapper for OpenAPI support using json_schemer
  class OpenApiWrapper
    class OpenApiError < StandardError; end
    class MissingReferenceError < OpenApiError; end

    def initialize(spec_hash, strict_reference_validation: true)
      @spec = spec_hash
      @strict_reference_validation = strict_reference_validation
      @schemas = {}
      @schema_validators = {}
      initialize_schemas
    end

    def self.parse(spec_hash, strict_reference_validation: true)
      new(spec_hash, strict_reference_validation:)
    end

    def components
      @components ||= ComponentsWrapper.new(self)
    end

    attr_reader :schemas, :spec

    private

    def initialize_schemas
      return unless @spec.dig('components', 'schemas')

      spec['components']['schemas'].each do |name, schema|
        @schemas[name] = SchemaWrapper.new(schema, name, self)
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
        @schema_def['properties']&.transform_values do |schema|
          if schema['$ref']
            ref_name = schema['$ref'].split('/').last
            SchemaWrapper.new(@parent.spec.dig('components', 'schemas', ref_name), ref_name, @parent)
          else
            SchemaWrapper.new(schema, nil, @parent)
          end
        end
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

      def format
        @schema_def['format']
      end

      def items
        return nil unless @schema_def['items']

        if @schema_def['items']['$ref']
          ref_name = @schema_def['items']['$ref'].split('/').last
          SchemaWrapper.new(@parent.spec.dig('components', 'schemas', ref_name), ref_name, @parent)
        else
          SchemaWrapper.new(@schema_def['items'], Generator::SchemaArray::GENERIC_ITEMS_NAME, @parent)
        end
      end
    end
  end
end
