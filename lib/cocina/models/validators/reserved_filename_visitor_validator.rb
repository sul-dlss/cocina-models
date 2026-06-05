# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that bare external identifier not used as a root filename or directory.
      # This is necessary due to the bare druid being used as part of the Stacks file layout.
      class ReservedFilenameVisitorValidator < BaseStructuralVisitorValidator
        def visit_file(file_hash:)
          return unless bare_external_identifier.present?

          filename = file_hash[:filename]
          return unless filename.present?

          invalid_filenames << filename if reserved?(filename)
        end

        def validate!
          return if invalid_filenames.empty?

          raise ValidationError, 'Bare druid may not be used as a filename or a base directory'
        end

        private

        def invalid_filenames
          @invalid_filenames ||= []
        end

        def reserved?(filename)
          filename == bare_external_identifier || filename.start_with?("#{bare_external_identifier}/")
        end

        def bare_external_identifier
          @bare_external_identifier ||= attributes[:externalIdentifier]&.delete_prefix('druid:')
        end
      end
    end
  end
end
