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
              #{name} = Types::String.constrained(
                format: /#{schema_doc.pattern}/i
              )
            end
          end
        RUBY
      end
    end
  end
end
