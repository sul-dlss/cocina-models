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
          DateTimeValidator,
          LanguageTagValidator,
          ReservedFilenameValidator
        ].freeze

        def self.validate(clazz, attributes)
          # This gets rid of nested model objects.
          attributes_hash = attributes.to_h.deep_transform_values do |value|
            value.class.name.starts_with?('Cocina::Models') ? value.to_h : value
          end.with_indifferent_access
          VALIDATORS.each { |validator| validator.validate(clazz, attributes_hash) }
        end

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
