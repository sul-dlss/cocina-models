# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that shelve and publish file attributes are set to false for dark DRO objects.
      class DarkVisitorValidator < BaseStructuralVisitorValidator
        def visit_file(file_hash:)
          return unless dark_object?

          invalid_files << file_hash if invalid?(file_hash)
        end

        def validate!
          return if invalid_files.empty?

          filenames = invalid_files.map { |file| file[:filename] || file[:label] }
          raise ValidationError, 'Not all files have dark access and/or are unshelved ' \
                                 "when object access is dark: #{filenames}"
        end

        private

        def invalid_files
          @invalid_files ||= []
        end

        def dark_object?
          # Checking for nil to account for default being dark.
          @dark_object ||= ['dark', nil].include?(attributes.dig(:access, :view))
        end

        def invalid?(file)
          # Ignore if a WARC
          return false if file[:hasMimeType] == 'application/warc'

          return true if file.dig(:administrative, :shelve)
          # Checking for nil to account for default being dark.
          return true if ['dark', nil].exclude?(file.dig(:access, :view))

          false
        end
      end
    end
  end
end
