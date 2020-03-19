# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating from an openapi array
    class SchemaArray < SchemaBase
      def generate
        "attribute :#{name.camelize(:lower)}, Types::Strict::Array.of(#{schema_doc.items.name})#{omittable}"
      end

      def omittable
        if required
          '.default([].freeze)'
        else
          '.meta(omittable: true)'
        end
      end
    end
  end
end
