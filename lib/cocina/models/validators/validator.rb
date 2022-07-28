# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Perform validation against all other Validators
      class Validator
        VALIDATORS = [
          OpenApiValidator,
          DarkValidator,
          PurlValidator,
          CatalogLinksValidator,
          AssociatedNameValidator,
          DescriptionTypesValidator,
          DescriptionValuesValidator,
          DateTimeValidator
        ].freeze

        def self.validate(clazz, attributes)
          # This gets rid of nested model objects.
          # Once DSA is on Rails 6, this can be:
          # attributes_hash = attributes.to_h.deep_transform_values do |value|
          #   value.class.name.starts_with?('Cocina::Models') ? value.to_h : value
          # end.with_indifferent_access
          # And add require 'active_support/core_ext/hash/deep_transform_values' to models file.

          # In the meantime, copying code.
          attributes_hash = deep_transform_values(attributes.to_h) do |value|
            value.class.name.starts_with?('Cocina::Models') ? value.to_h : value
          end.deep_symbolize_keys.with_indifferent_access
          VALIDATORS.each { |validator| validator.validate(clazz, attributes_hash) }
        end

        def self.deep_transform_values(object, &block)
          case object
          when Hash
            object.transform_values { |value| deep_transform_values(value, &block) }
          when Array
            object.map { |e| deep_transform_values(e, &block) }
          else
            yield(object)
          end
        end
        private_class_method :deep_transform_values
      end
    end
  end
end
