# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that the controlledDigitalLending attribute is set when view: 'stanford', download: 'none'
      # though it will set a default of "false" if not found instead of throwing a validation error
      class CdlValidator
        def self.validate(clazz, attributes)
          new(clazz, attributes).validate
        end

        def initialize(clazz, attributes)
          @clazz = clazz
          @attributes = attributes
        end

        def validate
          return unless meets_preconditions?

          raise ValidationError, 'controlledDigitalLending must be set when "view: stanford, download: none"'
        end

        private

        attr_reader :clazz, :attributes

        def meets_preconditions?
          dro? && attributes.dig(:access,
                                 :view) == 'stanford' && attributes.dig(:access,
                                                                        :download) == 'none' && attributes.dig(
                                                                          :access, :controlledDigitalLending
                                                                        ).nil?
        end

        def dro?
          (clazz::TYPES & DRO::TYPES).any?
        rescue NameError
          false
        end
      end
    end
  end
end
