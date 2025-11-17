# frozen_string_literal: true

module Cocina
  module Models
    # Same as a Collection, but doesn't have an externalIdentifier as one will be created
    class RequestCollection < BaseModel
      attr_accessor :cocinaVersion, :type, :label, :version, :access, :administrative, :description, :identification

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
