# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that a languageTag is valid according to RFC 4646, if one is present
      class LanguageTagValidator
        def self.validate(clazz, attributes)
          new(clazz, attributes).validate
        end

        def initialize(clazz, attributes)
          @clazz = clazz
          @attributes = attributes
        end

        def validate
          return unless meets_preconditions?

          return if valid_language_tag?

          raise ValidationError, 'The provided language tag is not valid according to RFC 4646: ' \
                                 "#{attributes[:languageTag]}"
        end

        private

        attr_reader :clazz, :attributes

        def meets_preconditions?
          file? && attributes[:languageTag].present?
        end

        def file?
          (clazz::TYPES & File::TYPES).any?
        rescue NameError
          false
        end

        def valid_language_tag?
          parsed_tag = I18n::Locale::Tag::Rfc4646.tag(attributes[:languageTag])

          parsed_tag.present? && parsed_tag.is_a?(I18n::Locale::Tag::Rfc4646)
        end
      end
    end
  end
end
