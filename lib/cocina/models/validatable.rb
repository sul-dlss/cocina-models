# frozen_string_literal: true

module Cocina
  module Models
    # Validate upon construction
    module Validatable
      extend ActiveSupport::Concern

      class_methods do
        def new(attributes = default_attributes, safe = false, validate = true, &)
          # Prevent nested models from validating if validate = false
          Thread.current[:top_level_validate] = validate unless Thread.current.key?(:top_level_validate)

          Validators::Validator.validate(self, attributes) if Thread.current[:top_level_validate]
          super(attributes, safe, &)
        ensure
          Thread.current[:top_level_validate] = nil
        end
      end

      def new(*args)
        validate = args.first.delete(:validate) if args.present?
        new_model = super
        Validators::Validator.validate(new_model.class, new_model) if validate || validate.nil?
        new_model
      end
    end
  end
end
