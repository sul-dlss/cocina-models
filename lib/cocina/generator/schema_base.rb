# frozen_string_literal: true

module Cocina
  module Generator
    # Base class for generating from openapi
    class SchemaBase
      attr_reader :schema_doc, :key, :required, :nullable, :parent, :relaxed

      def initialize(schema_doc, key: nil, required: false, nullable: false, parent: nil, relaxed: false)
        @schema_doc = schema_doc
        @key = key
        @required = required
        @nullable = nullable
        @parent = parent
        @relaxed = relaxed
      end

      def filename
        "#{name.underscore}.rb"
      end

      def name
        key || schema_doc.name
      end

      # Allows nillable values to be set to nil. This is useful when doing
      # an update and you want to clear out a value.
      def optional
        nullable || relaxed ? '.optional' : ''
      end

      def quote(item)
        return item unless schema_doc.type == 'string'

        "'#{item}'"
      end

      def description
        return '' unless schema_doc.description

        "# #{schema_doc.description}\n"
      end

      def deprecation
        return '' unless schema_doc.deprecated?

        "# DEPRECATED\n"
      end

      def example
        return '' unless schema_doc.example

        "# example: #{schema_doc.example}\n"
      end

      def relaxed_comment
        return '' unless relaxed

        "# Validation of this property is relaxed. See the openapi for full validation.\n"
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
          return 'Nominal::Any' if any_datatype?(doc)

          raise "#{schema_doc.type} not supported"
        end
      end

      def any_datatype?(doc)
        relaxed || doc.one_of&.map(&:type).all? { |o| %w[integer string].include?(o) }
      end

      def string_dry_datatype(doc)
        case doc.format
        when 'date-time'
          'Params::DateTime'
        else
          'Strict::String'
        end
      end

      def preamble
        "#{deprecation}#{description}#{example}#{relaxed_comment}"
      end
    end
  end
end
