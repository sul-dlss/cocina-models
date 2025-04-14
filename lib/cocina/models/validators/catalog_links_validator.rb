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

          validate_catalog('symphony')
          validate_catalog('folio')
          validate_sort_key
        end

        private

        attr_reader :clazz, :attributes

        def validate_catalog(catalog)
          refresh_catalog_links = refresh_catalog_links_for(catalog)

          return if refresh_catalog_links.length <= MAX_REFRESH_CATALOG_LINKS

          raise ValidationError, "Multiple catalog links have 'refresh' property set to true " \
                                 "(only one allowed) #{refresh_catalog_links}"
        end

        def validate_sort_key
          serials_links = catalog_links.select { |catalog_link| catalog_link[:catalog] == 'folio' && catalog_link[:sortKey].present? }
          serials_links.each do |catalog_link|
            # If partLabel is present, skip validation
            next if catalog_link[:partLabel].present?

            raise ValidationError, "partLabel must also be present if a sortKey is used in catalog link #{catalog_link}"
          end
        end

        def catalog_links
          @catalog_links ||= Array(attributes.dig(:identification, :catalogLinks))
        end

        def meets_preconditions?
          (dro? || collection?) && catalog_links.any?
        end

        def refresh_catalog_links_for(catalog)
          catalog_links.select { |catalog_link| catalog_link[:catalog] == catalog && catalog_link[:refresh] }
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
