# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Composite validator for structural metadata that uses a visitor pattern to validate files in a single pass.
      class CompositeStructuralValidator
        VALIDATORS = [
          DarkVisitorValidator,
          LanguageTagVisitorValidator,
          ReservedFilenameVisitorValidator
        ].freeze

        def self.validate(clazz, attributes)
          new(clazz, attributes).validate
        end

        def initialize(clazz, attributes, validators: VALIDATORS)
          @clazz = clazz
          @attributes = attributes
          @validators = validators.map { |v| v.new(attributes) }
        end

        def validate
          return unless meets_preconditions?

          Array(attributes.dig(:structural, :contains)).each do |fileset_hash|
            Array(fileset_hash.dig(:structural, :contains)).each do |file_hash|
              validators.each { |validator| validator.visit_file(file_hash:) }
            end
          end

          validators.each(&:validate!)
        end

        private

        attr_reader :clazz, :attributes, :validators

        def meets_preconditions?
          clazz::TYPES.intersect?(DRO::TYPES)
        rescue NameError
          false
        end
      end
    end
  end
end
