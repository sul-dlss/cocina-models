# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that a languageTag is valid according to RFC 4646, if one is present
      class LanguageTagVisitorValidator < BaseStructuralVisitorValidator
        def visit_file(file_hash:)
          return unless file_hash[:languageTag].present?
          return if I18n::Locale::Tag::Rfc4646.tag(file_hash[:languageTag]).present?

          invalid_files << file_hash
        end

        def validate!
          return if invalid_files.empty?

          descriptions = invalid_files.map do |file|
            "#{file[:filename] || file[:label]} (#{file[:languageTag]})"
          end
          raise ValidationError, "Some files have invalid language tags according to RFC 4646: #{descriptions.join(', ')}"
        end

        private

        def invalid_files
          @invalid_files ||= []
        end
      end
    end
  end
end
