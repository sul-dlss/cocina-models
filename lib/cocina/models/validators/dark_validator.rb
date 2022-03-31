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
          dro? && attributes.dig(:access, :view) == 'dark'
        end

        def dro?
          (clazz::TYPES & DRO::TYPES).any?
        rescue NameError
          false
        end

        def invalid_files
          @invalid_files ||=
            [].tap do |invalid_files|
              files.each do |file|
                invalid_files << file if invalid?(file)
              end
            end
        end

        def invalid_filenames
          invalid_files.map { |invalid_file| invalid_file[:filename] || invalid_file[:label] }
        end

        def invalid?(file)
          # Ignore if a WARC
          return false if file[:hasMimeType] == 'application/warc'

          return true if file.dig(:administrative, :shelve)
          return true if file.dig(:access, :view) != 'dark'

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
