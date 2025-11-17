# frozen_string_literal: true

module Cocina
  module Models
    # Digital Object Identifier (https://www.doi.org)
    class DOI < BaseModel
      # Union of: RepositoryDOI, PreregisteredRepositoryDOI, LibrariesDOI, DOIExceptions
    end
  end
end
