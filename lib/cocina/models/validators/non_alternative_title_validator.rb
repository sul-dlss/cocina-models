# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that not all titles have type 'alternative'
      class NonAlternativeTitleValidator
        def self.validate(...)
          new(...).validate
        end

        def initialize(clazz, attributes)
          @clazz = clazz
          @attributes = attributes
        end

        def validate
          return unless meets_preconditions?

          return unless titles.all? { |title| title[:type] == 'alternative' }

          raise ValidationError, "At least one title must have no type or a type other than 'alternative'."
        end

        private

        attr_reader :clazz, :attributes

        def meets_preconditions?
          [Cocina::Models::Description, Cocina::Models::RequestDescription].include?(clazz) &&
            titles.present?
        end

        def titles
          @titles ||= Array(attributes[:title])
        end
      end
    end
  end
end
