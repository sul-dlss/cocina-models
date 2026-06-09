# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that no file is marked shelve-only (shelve=true, publish=false, sdrPreserve=false).
      # SDR requires that any shelved file also be published or preserved; a shelve-only file
      # would be sent to the content store but never retrievable or preserved anywhere else.
      class ShelveOnlyVisitorValidator < BaseStructuralVisitorValidator
        def visit_file(file_hash:)
          admin = file_hash[:administrative]
          return unless admin[:shelve] && !admin[:publish] && !admin[:sdrPreserve]

          invalid_files << file_hash
        end

        def validate!
          return if invalid_files.empty?

          filenames = invalid_files.map { |file| file[:filename] || file[:label] }
          raise ValidationError, "Files cannot be shelved without publish or sdrPreserve: #{filenames}"
        end

        private

        def invalid_files
          @invalid_files ||= []
        end
      end
    end
  end
end
