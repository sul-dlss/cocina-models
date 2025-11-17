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
              #{preamble}#{name} = String
            end
          end
        RUBY
      end

      # Pattern and enum constraints are no longer enforced
      def pattern
        # No pattern constraints in simplified version
      end

      def enum
        # No enum constraints in simplified version
      end
    end
  end
end
