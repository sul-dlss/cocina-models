# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that shelve and publish file attributes are set to false for dark DRO objects.
      class DarkValidator
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

          raise ValidationError, 'Not all files have dark access and/or are unshelved ' \
                                 "when object access is dark: #{invalid_filenames}"
        end

        private

        attr_reader :clazz, :attributes

        def meets_preconditions?
          # Checking for nil to account for default being dark.
          dro? && ['dark', nil].include?(attributes.dig(:access, :view))
        end

        def dro?
          clazz::TYPES.intersect?(DRO::TYPES)
        rescue NameError
          false
        end

        def invalid_files
          @invalid_files ||= files.select { |file| invalid?(file) }
        end

        def invalid_filenames
          invalid_files.map { |invalid_file| invalid_file[:filename] || invalid_file[:label] }
        end

        def invalid?(file)
          # Ignore if a WARC
          return false if file[:hasMimeType] == 'application/warc'

          return true if file.dig(:administrative, :shelve)
          # Checking for nil to account for default being dark.
          return true if ['dark', nil].exclude?(file.dig(:access, :view))

          false
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
