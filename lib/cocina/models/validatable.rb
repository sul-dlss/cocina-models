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

          # Tracks that any Validatable construction triggered by `super` below is nested inside this one, so
          # JsonSchemaValidator can skip it: this object's own schema check above already covers.
          # See JsonSchemaValidator#validate.
          # In practice, this avoids doing schema validation on a DRO / AdminPolicy / Collection and
          # its nested Description.
          Thread.current[:cocina_construction_depth] = Thread.current[:cocina_construction_depth].to_i + 1
          begin
            super(attributes, safe, &)
          ensure
            Thread.current[:cocina_construction_depth] -= 1
          end
        ensure
          Thread.current[:top_level_validate] = nil
        end
      end

      def new(*args)
        validate = args.first.delete(:validate) if args.present?

        Thread.current[:cocina_construction_depth] = Thread.current[:cocina_construction_depth].to_i + 1
        begin
          new_model = super
        ensure
          Thread.current[:cocina_construction_depth] -= 1
        end

        Validators::Validator.validate(new_model.class, new_model) if validate || validate.nil?
        new_model
      end
    end
  end
end
