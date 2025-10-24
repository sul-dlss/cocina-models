# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating from an openapi reference
    class SchemaRef < SchemaBase
      def generate
        if required && !relaxed
          "#{preamble}attribute(:#{name.camelize(:lower)}, #{schema_doc.name}.default { #{schema_doc.name}.new })"
        else
          "#{preamble}attribute? :#{name.camelize(:lower)}, #{schema_doc.name}.optional"
        end
      end
    end
  end
end
