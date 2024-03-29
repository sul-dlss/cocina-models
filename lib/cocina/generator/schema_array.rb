# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating from an openapi array
    class SchemaArray < SchemaBase
      def generate
        "attribute :#{name.camelize(:lower)}, Types::Strict::Array.of(#{array_of_type}).default([].freeze)"
      end

      def array_of_type
        schema_doc.items.name || dry_datatype(schema_doc.items)
      end
    end
  end
end
