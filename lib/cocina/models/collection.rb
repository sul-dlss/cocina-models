# frozen_string_literal: true

module Cocina
  module Models
    # A group of Digital Repository Objects that indicate some type of conceptual grouping
    # within the domain that is worth reusing across the system.
    class Collection < BaseModel
      attr_accessor :cocinaVersion, :type, :externalIdentifier, :label, :version, :access, :administrative, :description, :identification

      include Validatable

      TYPES = [
        'https://cocina.sul.stanford.edu/models/collection',
        'https://cocina.sul.stanford.edu/models/curated-collection',
        'https://cocina.sul.stanford.edu/models/user-collection',
        'https://cocina.sul.stanford.edu/models/exhibit',
        'https://cocina.sul.stanford.edu/models/series'
      ].freeze
    end
  end
end
