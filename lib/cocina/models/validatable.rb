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

      def new(*args)
        validate = args.first.delete(:validate) if args.present?
        new_model = super(*args)
        Validator.validate(new_model.class, new_model.to_h) if (validate || validate.nil?) && self.class.name
        new_model
      end
    end
  end
end