# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that filenames do not contain newline characters.
      # Newlines in filenames cause problems for many applications and create
      # preservation risk when copying to filesystems that do not support them.
      class NewlineFilenameValidator
        def self.validate(clazz, attributes)
          new(clazz, attributes).validate
        end

        def initialize(clazz, attributes)
          @clazz = clazz
          @attributes = attributes
        end

        def validate
          return unless dro?

          offending = filenames.find { |filename| filename.match?(/[\n\r]/) }
          return unless offending

          raise ValidationError, "Filename contains a newline character: #{offending.inspect}"
        end

        private

        attr_reader :clazz, :attributes

        def dro?
          clazz::TYPES.intersect?(DRO::TYPES) && attributes[:externalIdentifier].present?
        rescue NameError
          false
        end

        def filenames
          [].tap do |filenames|
            next if attributes.dig(:structural, :contains).nil?

            attributes[:structural][:contains].each do |fileset|
              next if fileset.dig(:structural, :contains).nil?

              fileset[:structural][:contains].each do |file|
                filenames << file[:filename] unless file[:filename].nil?
              end
            end
          end
        end
      end
    end
  end
end
