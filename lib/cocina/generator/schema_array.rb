# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating from an openapi array
    class SchemaArray < SchemaBase
      GENERIC_ITEMS_NAME = 'items'

      def generate
        "#{preamble}attribute :#{name.camelize(:lower)}, Types::Strict::Array.of(#{array_of_type}).default([].freeze)"
      end

      def array_of_type
        items_name = schema_doc.items.name
        return items_name unless items_name == GENERIC_ITEMS_NAME

        dry_datatype(schema_doc.items)
      end
    end
  end
end
