# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating from an openapi schema
    class Schema < SchemaBase
      def schema_properties
        @schema_properties ||= schema_doc.properties.map do |key, properties_doc|
          property_class_for(properties_doc).new(properties_doc,
                                                 key: key,
                                                 required: schema_doc.requires?(properties_doc),
                                                 parent: self)
        end
      end

      def generate
        <<~RUBY
          # frozen_string_literal: true

          module Cocina
            module Models
              class #{name} < Struct

                #{types}

                #{model_attributes}

                #{validate}
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
        type_properties_doc = schema_doc.properties['type']
        return '' if type_properties_doc.nil?

        types_list = type_properties_doc.enum.map { |item| "'#{item}'" }.join(",\n ")

        <<~RUBY
          include Checkable

          TYPES = [#{types_list}].freeze
        RUBY
      end

      def validate
        return '' unless validatable?

        <<~RUBY
          def self.new(attributes = default_attributes, safe = false, validate = true, &block)
            Validator.validate(self, attributes.with_indifferent_access) if validate
            super(attributes, safe, &block)
                end
        RUBY
      end

      def validatable?
        !schema_doc.node_context.document.paths["/validate/#{schema_doc.name}"].nil?
      end
    end
  end
end
