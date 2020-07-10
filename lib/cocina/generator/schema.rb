# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating from an openapi schema
    class Schema < SchemaBase
      def schema_properties
        @schema_properties ||= (properties + all_of_properties).uniq(&:key)
      end

      def generate
        <<~RUBY
          # frozen_string_literal: true

          module Cocina
            module Models
              class #{name} < Struct
          #{types}#{model_attributes}#{validate}
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
        return '' if type_properties_doc.nil? || type_properties_doc.enum.nil?

        types_list = type_properties_doc.enum.map { |item| "        '#{item}'" }.join(",\n")

        "      include Checkable\n\n" \
        "      TYPES = [\n#{types_list}\n      ].freeze\n\n"
      end

      def validate
        return '' unless validatable?

        "\n\n" \
        "      def self.new(attributes = default_attributes, safe = false, validate = true, &block)\n" \
        "        Validator.validate(self, attributes.with_indifferent_access) if validate && name\n" \
        "        super(attributes, safe, &block)\n" \
        '      end'
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

      def all_of_properties_for(doc)
        return [] if doc.all_of.nil?

        doc.all_of.map do |all_of_schema|
          # All of for this + recurse
          schema_properties_for(all_of_schema) + all_of_properties_for(all_of_schema)
        end.flatten
      end

      def schema_properties_for(doc)
        doc.properties.map do |key, properties_doc|
          property_class_for(properties_doc).new(properties_doc,
                                                 key: key,
                                                 required: doc.requires?(properties_doc),
                                                 parent: self)
        end
      end
    end
  end
end
