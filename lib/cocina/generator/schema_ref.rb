# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating from an openapi reference
    class SchemaRef < SchemaBase
      def generate
        # TODO: Remove this when cocina-models 1.0.0 is released.
        @camelcase_properties << name.to_sym unless name == name.underscore

        if required && !relaxed
          "attribute(:#{name.underscore}, #{schema_doc.name}.default { #{schema_doc.name}.new })"
        else
          "attribute :#{name.underscore}, #{schema_doc.name}.optional.meta(omittable: true)"
        end
      end
    end
  end
end
