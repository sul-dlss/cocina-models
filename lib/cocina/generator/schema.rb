# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating Data classes from OpenAPI schemas
    class Schema < SchemaBase
      def generate
        attributes = collect_attributes
        type_constants = collect_type_constants

        <<~RUBY
          # frozen_string_literal: true

          module Cocina
            module Models
              #{preamble}class #{name} < BaseModel
                #{attributes.map { |attr| "attr_accessor #{attr}" }.join("\n        ")}
                #{validate}
                #{type_constants}
              end
            end
          end
        RUBY
      end

      private

      def validate
        return '' unless validatable?

        <<~RUBY
          include Validatable
        RUBY
      end

      def validatable?
        !schema_doc.root.paths.path["/validate/#{schema_doc.name}"].nil? && !lite
      end

      def collect_attributes
        attributes = []

        # Get properties from the schema
        if schema_doc.properties && !schema_doc.properties.empty?
          schema_doc.properties.each_key do |prop_name|
            attributes << ":#{prop_name.camelize(:lower)}"
          end
        end

        # Get properties from allOf schemas
        if schema_doc.all_of
          schema_doc.all_of.each do |all_of_schema|
            next unless all_of_schema.properties

            all_of_schema.properties.each_key do |prop_name|
              attr_name = ":#{prop_name.camelize(:lower)}"
              attributes << attr_name unless attributes.include?(attr_name)
            end
          end
        end

        # Get properties from oneOf schemas
        if schema_doc.one_of
          schema_doc.one_of.each do |one_of_schema|
            next unless one_of_schema.properties

            one_of_schema.properties.each_key do |prop_name|
              attr_name = ":#{prop_name.camelize(:lower)}"
              attributes << attr_name unless attributes.include?(attr_name)
            end
          end
        end

        # Ensure we have at least one attribute for Data.define
        attributes << ':data' if attributes.empty?

        attributes.uniq
      end

      def collect_type_constants
        # Find type property and create TYPES constant if it has enum values
        type_prop = find_type_property
        return '' unless type_prop && type_prop.enum

        types_list = type_prop.enum.map { |item| "'#{item}'" }.join(",\n        ")

        <<~RUBY.strip
          TYPES = [
            #{types_list}
          ].freeze
        RUBY
      end

      def find_type_property
        # Look for 'type' property in main schema
        return schema_doc.properties['type'] if schema_doc.properties && schema_doc.properties['type']

        # Look in allOf schemas
        if schema_doc.all_of
          schema_doc.all_of.each do |all_of_schema|
            return all_of_schema.properties['type'] if all_of_schema.properties && all_of_schema.properties['type']
          end
        end

        # Look in oneOf schemas
        if schema_doc.one_of
          schema_doc.one_of.each do |one_of_schema|
            return one_of_schema.properties['type'] if one_of_schema.properties && one_of_schema.properties['type']
          end
        end

        nil
      end
    end
  end
end
