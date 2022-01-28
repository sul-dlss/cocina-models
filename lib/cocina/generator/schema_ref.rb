# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating from an openapi reference
    class SchemaRef < SchemaBase
      def generate
        if required && !relaxed
          "attribute(:#{name.underscore}, #{schema_doc.name}.default { #{schema_doc.name}.new })"
        else
          "attribute :#{name.underscore}, #{schema_doc.name}.optional.meta(omittable: true)"
        end
      end
    end
  end
end
