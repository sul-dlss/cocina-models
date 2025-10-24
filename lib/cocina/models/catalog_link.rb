# frozen_string_literal: true

module Cocina
  module Models
    # A linkage between an object and a catalog record
    CatalogLink = FolioCatalogLink | SymphonyCatalogLink
  end
end
