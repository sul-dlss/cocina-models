# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that bare external identifier not used as a root filename or directory.
      # This is necessary due to the bare druid being used as part of the Stacks file layout.
      class ReservedFilenameValidator
        def self.validate(clazz, attributes)
          new(clazz, attributes).validate
        end

        def initialize(clazz, attributes)
          @clazz = clazz
          @attributes = attributes
        end

        def validate
          return unless dro?

          return if filenames.none? { |filename| reserved?(filename) }

          raise ValidationError, 'Bare druid may not be used as a filename or a base directory'
        end

        private

        attr_reader :clazz, :attributes

        def dro?
          (clazz::TYPES & DRO::TYPES).any? && attributes[:externalIdentifier].present?
        rescue NameError
          false
        end

        def reserved?(filename)
          filename == bare_external_identifier || filename.start_with?("#{bare_external_identifier}/")
        end

        def bare_external_identifier
          @bare_external_identifier ||= attributes[:externalIdentifier].delete_prefix('druid:')
        end

        def filenames
          [].tap do |filenames|
            next if attributes.dig(:structural, :contains).nil?

            attributes[:structural][:contains].each do |fileset|
              next if fileset.dig(:structural, :contains).nil?

              fileset[:structural][:contains].each do |file|
                filenames << file[:filename] if file[:filename].present?
              end
            end
          end
        end
      end
    end
  end
end
