# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating from an openapi schema
    class Datatype < SchemaBase
      def generate
        <<~RUBY
          # frozen_string_literal: true

          module Cocina
            module Models
              #{name} = Types::String#{pattern}#{enum}
            end
          end
        RUBY
      end

      def pattern
        return unless schema_doc.pattern

        ".constrained(format: /#{schema_doc.pattern}/)"
      end

      def enum
        return unless schema_doc.enum

        ".enum(#{schema_doc.enum.map { |item| quote(item) }.join(', ')})"
      end
    end
  end
end
