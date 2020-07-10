# frozen_string_literal: true

module Cocina
  module Generator
    # Base class for generating from openapi
    class SchemaBase
      attr_reader :schema_doc, :key, :required, :parent

      def initialize(schema_doc, key: nil, required: false, parent: nil)
        @schema_doc = schema_doc
        @key = key
        @required = required
        @parent = parent
      end

      def filename
        "#{name.underscore}.rb"
      end

      def name
        key || schema_doc.name
      end

      def omittable
        return '' if required

        '.meta(omittable: true)'
      end

      def quote(item)
        return item unless schema_doc.type == 'string'

        "'#{item}'"
      end

      def description
        return '' unless schema_doc.description

        "      # #{schema_doc.description}\n"
      end

      def example
        return '' unless schema_doc.example

        "      # example: #{schema_doc.example}\n"
      end

      def dry_datatype(doc)
        case doc.type
        when 'integer'
          'Strict::Integer'
        when 'string'
          string_dry_datatype(doc)
        when 'boolean'
          'Strict::Bool'
        else
          raise "#{schema_doc.type} not supported"
        end
      end

      def string_dry_datatype(doc)
        case doc.format
        when 'date-time'
          'Params::DateTime'
        else
          'Strict::String'
        end
      end
    end
  end
end
