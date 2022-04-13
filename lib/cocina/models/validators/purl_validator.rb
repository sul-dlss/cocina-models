# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that Purl matches the external identifier (druid)
      class PurlValidator
        def self.validate(clazz, attributes)
          new(clazz, attributes).validate
        end

        def initialize(clazz, attributes)
          @clazz = clazz
          @attributes = attributes
        end

        def validate
          return unless meets_preconditions?

          return if identifier_from_druid == identifier_from_purl

          raise ValidationError, "Purl mismatch: #{druid} purl does not match object druid."
        end

        private

        attr_reader :clazz, :attributes

        def meets_preconditions?
          purl
        end

        def druid
          @druid ||= attributes[:externalIdentifier]
        end

        def purl
          @purl ||= attributes.dig(:description, :purl)
        end

        def identifier_from_druid
          druid.delete_prefix('druid:')
        end

        def identifier_from_purl
          purl.split('/').last
        end
      end
    end
  end
end
