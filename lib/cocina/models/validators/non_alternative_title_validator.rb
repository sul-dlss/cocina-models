# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that at least one title with no type or a type other than "alternative" is present.
      class NonAlternativeTitleValidator
        def self.validate(clazz, attributes)
          new(clazz, attributes).validate
        end

        def initialize(clazz, attributes)
          @clazz = clazz
          @attributes = attributes
        end

        def validate
          return unless meets_preconditions?

          return if resources.all? { |resource| valid?(resource) }

          raise ValidationError,
                "At least one title must have no type or a type other than 'alternative'."
        end

        private

        attr_reader :clazz, :attributes

        def meets_preconditions?
          [Cocina::Models::Description, Cocina::Models::RequestDescription].include?(clazz)
        end

        def valid?(resource)
          titles = Array(resource[:title])
          titles.empty? || titles.any? { |title| title[:type].nil? || title[:type] != 'alternative' }
        end

        def resources
          @resources ||= [description_attributes] + Array(description_attributes[:relatedResource])
        end

        def description_attributes
          @description_attributes ||= if [Cocina::Models::Description,
                                          Cocina::Models::RequestDescription].include?(clazz)
                                        attributes
                                      else
                                        attributes[:description] || {}
                                      end
        end
      end
    end
  end
end
