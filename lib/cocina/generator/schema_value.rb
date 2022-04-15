# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating from an openapi value
    class SchemaValue < SchemaBase
      def generate
        # optional has to come before default or the default value that gets set will be nil.
        if required && !relaxed
          "#{preamble}attribute :#{name.camelize(:lower)}, #{type}"
        else
          "#{preamble}attribute? :#{name.camelize(:lower)}, #{type}"
        end
      end

      private

      def type
        "Types::#{dry_datatype(schema_doc)}#{optional}#{default}#{enum}"
      end

      def preamble
        "#{description}#{example}#{relaxed_comment}"
      end

      def enum
        return '' if !schema_doc.enum || relaxed

        items = use_types? ? "*#{parent.name}::TYPES" : schema_doc.enum.map { |item| quote(item) }.join(', ')

        ".enum(#{items})"
      end

      def use_types?
        parent.is_a?(Schema) && key == 'type'
      end

      def default
        # Provide version as default for cocinaVersion
        return '.default(Cocina::Models::VERSION)' if name == 'cocinaVersion'

        # If type is boolean and default is false, erroneously getting a nil.
        # Assuming that if required, then default is false.
        default = schema_doc.default
        default = false if default.nil? && schema_doc.type == 'boolean' && required

        return '' if default.nil?

        ".default(#{quote(default)})"
      end
    end
  end
end
