# frozen_string_literal: true

module Cocina
  module Generator
    # Base class for generating from openapi
    class SchemaBase
      attr_reader :schema_doc, :key, :required, :nullable, :parent, :relaxed, :schemas, :lite

      def initialize(schema_doc, key: nil, required: false, nullable: false, parent: nil, relaxed: false, schemas: [], lite: false)
        @schema_doc = schema_doc
        @key = key
        @required = required
        @nullable = nullable
        @parent = parent
        @relaxed = relaxed
        @schemas = schemas
        @lite = lite
      end

      def filename
        "#{name.underscore}.rb"
      end

      def name
        "#{key || schema_doc.name}#{lite ? 'Lite' : ''}"
      end

      # Allows nullable values to be set to nil. This is useful when doing an
      # update and you want to clear out a value. The logic also permits custom
      # types (e.g., `Barcode`, `SourceId`) to be nullable if they are not
      # required.
      def optional
        return '.optional' if nullable ||
                              relaxed ||
                              (custom_type? && !required)

        ''
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

      # dry-types-based types contain the word `Types` (e.g., `Types::String`), and custom types (e.g., `SourceId`) do not
      def custom_type?
        !dry_datatype(schema_doc).match?('Types')
      end

      def dry_datatype(doc)
        return doc.name if doc.name.present? && schemas.include?(doc.name)

        datatype_from_doc_names(doc) ||
          datatype_from_doc_type(doc) ||
          raise("#{doc.type} not supported")
      end

      def datatype_from_doc_type(doc)
        case doc.type
        when 'integer'
          'Types::Strict::Integer'
        when 'string'
          string_dry_datatype(doc)
        when 'boolean'
          'Types::Strict::Bool'
        else
          return 'Types::Nominal::Any' if any_datatype?(doc)

          raise "#{schema_doc.type} not supported"
        end
      end

      def datatype_from_doc_names(doc)
        return unless defined_datatypes?(doc)

        doc.one_of.map(&:name).join(' | ')
      end

      def defined_datatypes?(doc)
        doc.one_of&.map(&:name)&.all? { |name| name.present? && schemas.include?(name) }
      end

      def any_datatype?(doc)
        relaxed || doc.one_of&.map(&:type)&.all? { |o| %w[integer string].include?(o) }
      end

      def string_dry_datatype(doc)
        format = case doc.format
                 when 'date-time'
                   'Types::Params::DateTime'
                 else
                   'Types::Strict::String'
                 end
        return format unless doc.pattern

        "Types::Strict::String.constrained(format: /#{doc.pattern}/)"
      end

      def preamble
        "#{deprecation}#{description}#{example}#{relaxed_comment}"
      end
    end
  end
end
