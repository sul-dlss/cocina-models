# frozen_string_literal: true

module Cocina
  module Models
    # Validate upon construction
    module Validatable
      extend ActiveSupport::Concern

      class_methods do
        def new(attributes = default_attributes, safe = false, validate = true, &block)
          Validator.validate(self, attributes.with_indifferent_access) if validate && name
          super(attributes, safe, &block)
        end
      end

      def new(attrs)
        validate = attrs.delete(:validate) if attrs.present?
        new_model = super(self.class.underscore_attributes(attrs))
        Validator.validate(new_model.class, new_model.to_h) if (validate || validate.nil?) && self.class.name
        new_model
      end
    end
  end
end
