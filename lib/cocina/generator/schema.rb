# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating from a JSON schema
    class Schema < SchemaBase
      def schema_properties
        @schema_properties ||= (
          schema_properties_for(schema_doc) +
          all_of_properties_for(schema_doc) +
          one_of_properties_for(schema_doc)
        ).uniq(&:key)
      end

      VALIDATABLE_TYPES = %w[DRO RequestDRO DROWithMetadata Collection RequestCollection CollectionWithMetadata AdminPolicy
                             RequestAdminPolicy AdminPolicyWithMetadata Description RequestDescription].freeze

      def generate
        <<~RUBY
          # frozen_string_literal: true

          module Cocina
            module Models
              #{preamble}class #{name} < Struct

                #{validatable}
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

      def validatable
        return '' if VALIDATABLE_TYPES.exclude?(name)

        <<~RUBY
          include Validatable
        RUBY
      end

      def all_of_properties_for(doc)
        Array(doc.all_of).flat_map do |all_of_schema|
          schema_properties_for(all_of_schema) +
            all_of_properties_for(all_of_schema) +
            one_of_properties_for(all_of_schema)
        end
      end

      def one_of_properties_for(doc)
        Array(doc.one_of).flat_map do |one_of_schema|
          schema_properties_for(one_of_schema, relaxed: true) +
            all_of_properties_for(one_of_schema) +
            one_of_properties_for(one_of_schema)
        end
      end

      def schema_properties_for(doc, relaxed: nil)
        relax_all_properties = relaxed

        Array(doc.properties).map do |key, properties_doc|
          clazz = property_class_for(properties_doc)
          relaxed = relax_all_properties.nil? ? lite && clazz != SchemaValue : relax_all_properties

          clazz.new(properties_doc,
                    key: key,
                    required: doc.required&.include?(key),
                    relaxed: relaxed,
                    nullable: Array(properties_doc.type).include?('null'),
                    parent: self,
                    schemas: schemas)
        end
      end
    end
  end
end
