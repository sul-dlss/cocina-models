# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Perform validation against all other Validators
      class Validator
        VALIDATORS = [
          JsonSchemaValidator,
          CompositeDescriptionValidator,
          CompositeStructuralValidator,
          PurlValidator,
          CatalogLinksValidator,
          AssociatedNameValidator,
          MarcRelatorRoleValidator,
          NonAlternativeTitleValidator
        ].freeze

        def self.validate(clazz, attributes, validators: VALIDATORS)
          hash = attributes_hash(attributes)
          validators.each { |validator| validator.validate(clazz, hash) }
        end

        # @return [Hash] attributes with any embedded Cocina model instances flattened to hashes
        def self.attributes_hash(attributes)
          # Dry::Struct#to_h is already fully recursive (Dry::Struct::Hashify flattens nested
          # structs all the way down), so a Cocina model instance's #to_h has no embedded
          # Cocina model instances left to flatten and the deep walk below would be a no-op.
          return attributes.to_h.with_indifferent_access if attributes.class.name.starts_with?('Cocina::Models')

          attributes.to_h.deep_transform_values do |value|
            value.class.name.starts_with?('Cocina::Models') ? value.to_h : value
          end.with_indifferent_access
        end
        private_class_method :attributes_hash

        def self.deep_transform_values(object, ...)
          case object
          when Hash
            object.transform_values { |value| deep_transform_values(value, ...) }
          when Array
            object.map { |e| deep_transform_values(e, ...) }
          else
            yield(object)
          end
        end
        private_class_method :deep_transform_values
      end
    end
  end
end
