# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating from an openapi schema
    class Schema < SchemaBase
      def schema_properties
        @schema_properties ||= (properties + all_of_properties + one_of_properties).uniq(&:key)
      end

      def generate
        <<~RUBY
          # frozen_string_literal: true

          module Cocina
            module Models
              class #{name} < Struct

                #{validate}
                #{types}

                #{model_attributes}
              end
            end
          end
        RUBY
      end

      private

      def property_class_for(properties_doc)
        case properties_doc.type
        when 'object'
          # As a useful simplification, all objects must be references to schemas.
          raise "Must use a reference for #{schema_doc.inspect}" unless properties_doc.name

          SchemaRef
        when 'array'
          SchemaArray
        else
          SchemaValue
        end
      end

      def model_attributes
        schema_properties.map(&:generate).join("\n")
      end

      def types
        type_schema_property = schema_properties.find { |schema_property| schema_property.key == 'type' }
        return '' if type_schema_property.nil?

        type_schema_doc = type_schema_property.schema_doc
        return '' if type_schema_doc.enum.nil?

        types_list = type_schema_doc.enum.map { |item| "'#{item}'" }.join(",\n ")

        <<~RUBY
          include Checkable

          TYPES = [#{types_list}].freeze
        RUBY
      end

      def validate
        return '' unless validatable?

        <<~RUBY
          include Validatable
        RUBY
      end

      def validatable?
        !schema_doc.node_context.document.paths["/validate/#{schema_doc.name}"].nil?
      end

      def properties
        schema_properties_for(schema_doc)
      end

      def all_of_properties
        all_of_properties_for(schema_doc)
      end

      def one_of_properties
        one_of_properties_for(schema_doc)
      end

      def all_of_properties_for(doc)
        return [] if doc.all_of.nil?

        doc.all_of.map do |all_of_schema|
          # All of for this + recurse
          schema_properties_for(all_of_schema) +
            all_of_properties_for(all_of_schema) +
            one_of_properties_for(all_of_schema)
        end.flatten
      end

      def one_of_properties_for(doc)
        return [] if doc.one_of.nil?

        # All properties must be objects.
        unless doc.one_of.all? { |schema| schema.type == 'object' }
          raise 'All properties for oneOf must be objects'
        end

        doc.one_of.flat_map do |one_of_doc|
          one_of_doc.properties.map do |key, properties_doc|
            property_class_for(properties_doc).new(properties_doc,
                                                   key: key,
                                                   # The property does less validation because may vary between
                                                   # different oneOf schemas. Validation is still performed
                                                   # by openAPI.
                                                   relaxed: true,
                                                   parent: self)
          end
        end
      end

      def schema_properties_for(doc)
        doc.properties.map do |key, properties_doc|
          property_class_for(properties_doc).new(properties_doc,
                                                 key: key,
                                                 required: doc.requires?(key),
                                                 nullable: properties_doc.nullable?,
                                                 parent: self)
        end
      end
    end
  end
end
