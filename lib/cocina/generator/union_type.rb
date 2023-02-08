# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating a union type
    class UnionType < SchemaBase
      def generate
        <<~RUBY
          # frozen_string_literal: true

          module Cocina
            module Models
              #{name} = #{type_names}
            end
          end
        RUBY
      end

      def type_names
        schema_doc.one_of.map(&:name).join(' | ')
      end
    end
  end
end
