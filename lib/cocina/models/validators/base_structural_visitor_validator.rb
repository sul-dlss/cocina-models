# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Super class for structural validators that use a visitor pattern.
      class BaseStructuralVisitorValidator
        def initialize(attributes)
          @attributes = attributes
        end

        def visit_file(file_hash:); end

        # @raise [ValidationError] if validation fails
        def validate!; end

        private

        attr_reader :attributes
      end
    end
  end
end
