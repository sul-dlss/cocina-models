# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Composite validator for description that uses a visitor pattern to validate in a single pass.
      class CompositeDescriptionValidator
        VALIDATORS = [
          DescriptionTypesVisitorValidator,
          DescriptionIdentifierSourceCodeVisitorValidator,
          DescriptionRoleSourceCodeVisitorValidator,
          DescriptionNameSourceCodeVisitorValidator,
          DescriptionFormResourceTypeVisitorValidator,
          DescriptionValuesVisitorValidator,
          DescriptionDateTimeVisitorValidator,
          DescriptionEventDateVisitorValidator,
          DescriptionSubjectTemporalEncodingVisitorValidator,
          DescriptionLocationSourceCodeVisitorValidator
        ].freeze

        def self.validate(clazz, attributes)
          new(clazz, attributes).validate
        end

        def initialize(clazz, attributes, validators: VALIDATORS)
          @clazz = clazz
          @attributes = attributes
          @validators = validators.map(&:new)
        end

        def validate
          return unless meets_preconditions?

          validate_obj(obj: attributes, path: [])

          validators.each(&:validate!)
        end

        private

        attr_reader :clazz, :attributes, :validators

        def meets_preconditions?
          [Cocina::Models::Description, Cocina::Models::RequestDescription].include?(clazz)
        end

        def validate_hash(hash:, path:)
          validators.each { |validator| validator.visit_hash(hash:, path:) }
          hash.each do |key, obj|
            validate_obj(obj:, path: path + [key])
          end
        end

        def validate_array(array:, path:)
          validators.each { |validator| validator.visit_array(array:, path:) }
          array.each_with_index do |obj, index|
            validate_obj(obj:, path: path + [index])
          end
        end

        def validate_obj(obj:, path:)
          validators.each { |validator| validator.visit_obj(obj:, path:) }
          validate_hash(hash: obj, path: path) if obj.is_a?(Hash)
          validate_array(array: obj, path: path) if obj.is_a?(Array)
        end
      end
    end
  end
end
