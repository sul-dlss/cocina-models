# frozen_string_literal: true

module Cocina
  module Models
    # Digital Object Identifier (https://www.doi.org)
    DOI = RepositoryDOI | PreregisteredRepositoryDOI | LibrariesDOI | DOIExceptions
  end
end
