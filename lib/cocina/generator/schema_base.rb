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
        return doc.name if doc.name.present? && Cocina::Models.const_defined?(doc.name)

        datatype_from_doc_type(doc) ||
          datatype_from_doc_names(doc) ||
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
        if defined_datatypes?(doc)
          doc.one_of.map(&:name).join(' | ')
        elsif any_datatype?(doc)
          'Types::Nominal::Any'
        end
      end

      def defined_datatypes?(doc)
        doc.one_of&.map(&:name).all? { |name| name.present? && Cocina::Models.const_defined?(name) }
      end

      def any_datatype?(doc)
        relaxed || doc.one_of&.map(&:type).all? { |o| %w[integer string].include?(o) }
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
