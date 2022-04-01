# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Perform validation against all other Validators
      class Validator
        VALIDATORS = [OpenApiValidator, DarkValidator].freeze

        def self.validate(clazz, attributes)
          VALIDATORS.each { |validator| validator.validate(clazz, attributes) }
        end
      end
    end
  end
end
