# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that descriptive has a webarchive url
      class WasSeedValidator
        def self.validate(_, attributes)
          new(_, attributes).validate
        end

        def initialize(_, attributes)
          @attributes = attributes
        end

        def validate
          return unless attributes[:type] == 'https://cocina.sul.stanford.edu/models/webarchive-seed'

          archived_website_url = attributes.dig(:description, :access, :url)&.
            find { |url| url[:displayLabel] == 'Archived website' }&.fetch(:value)
          return if archived_website_url&.include?('/*/')

          raise ValidationError, 'Archived website url is not present'
        end

        private

        attr_reader :clazz, :attributes
      end
    end
  end
end
