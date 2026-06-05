# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Super class for description validators that use a visitor pattern.
      class BaseDescriptionVisitorValidator
        def visit_hash(hash:, path:); end

        def visit_array(array:, path:); end

        def visit_obj(obj:, path:); end

        # @raise [ValidationError] if validation fails
        def validate!; end

        def path_to_s(path)
          # This matches the format used by descriptive spreadsheets
          path_str = ''
          path.each_with_index do |part, index|
            if part.is_a?(Integer)
              path_str += (part + 1).to_s
            else
              path_str += '.' if index.positive?
              path_str += part.to_s
            end
          end
          path_str
        end
      end
    end
  end
end
