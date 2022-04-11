# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates that only a single CatalogLink has refresh set to true
      class CatalogLinksValidator
        MAX_REFRESH_CATALOG_LINKS = 1

        def self.validate(clazz, attributes)
          new(clazz, attributes).validate
        end

        def initialize(clazz, attributes)
          @clazz = clazz
          @attributes = attributes
        end

        def validate
          return unless meets_preconditions?

          return if refresh_catalog_links.length <= MAX_REFRESH_CATALOG_LINKS

          raise ValidationError, "Multiple catalog links have 'refresh' property set to true " \
                                 "(only one allowed) #{refresh_catalog_links}"
        end

        private

        attr_reader :clazz, :attributes

        def meets_preconditions?
          (dro? || collection?) && Array(attributes.dig(:identification, :catalogLinks)).any?
        end

        def refresh_catalog_links
          attributes.dig(:identification, :catalogLinks).select { |catalog_link| catalog_link[:refresh] }
        end

        def dro?
          (clazz::TYPES & DRO::TYPES).any?
        rescue NameError
          false
        end

        def collection?
          (clazz::TYPES & Collection::TYPES).any?
        rescue NameError
          false
        end
      end
    end
  end
end
