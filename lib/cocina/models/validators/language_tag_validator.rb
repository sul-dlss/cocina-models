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

          return if invalid_files.empty?

          raise ValidationError, 'Some files have invalid language tags according to RFC 4646: ' \
                                 "#{invalid_filenames_with_language_tags.join(', ')}"
        end

        private

        attr_reader :clazz, :attributes

        def meets_preconditions?
          dro?
        end

        def dro?
          clazz::TYPES.intersect?(DRO::TYPES)
        rescue NameError
          false
        end

        def valid_language_tag?(file)
          # I18n::Locale::Tag::Rfc4646.tag will return an instance of I18n::Locale::Tag::Rfc4646 (with fields like language, script,
          # region) for strings that can be parsed according to RFC 4646, and nil for strings that do not conform to the spec.
          I18n::Locale::Tag::Rfc4646.tag(file[:languageTag]).present?
        end

        def invalid_files
          @invalid_files ||= language_tag_files.reject { |file| valid_language_tag?(file) }
        end

        def invalid_filenames_with_language_tags
          invalid_files.map { |invalid_file| "#{invalid_file[:filename] || invalid_file[:label]} (#{invalid_file[:languageTag]})" }
        end

        def language_tag_files
          files.select { |file| file[:languageTag].present? }
        end

        def files
          [].tap do |files|
            next if attributes.dig(:structural, :contains).nil?

            attributes[:structural][:contains].each do |fileset|
              next if fileset.dig(:structural, :contains).nil?

              fileset[:structural][:contains].each do |file|
                files << file
              end
            end
          end
        end
      end
    end
  end
end
