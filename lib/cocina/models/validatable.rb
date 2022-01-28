# frozen_string_literal: true

module Cocina
  module Models
    # Validate upon construction
    module Validatable
      extend ActiveSupport::Concern

      class_methods do
        def new(attributes = default_attributes, safe = false, validate = true, &block)
          attrs = underscore_attributes(attributes)
          Validators::Validator.validate(self, attrs) if validate
          super(attrs, safe, &block)
        end
      end

      def new(attrs)
        validate = attrs.delete(:validate) if attrs.present?
        new_model = super(self.class.underscore_attributes(attrs))
        Validators::Validator.validate(new_model.class, new_model.to_h) if (validate || validate.nil?) && self.class.name
        new_model
      end
    end
  end
end
