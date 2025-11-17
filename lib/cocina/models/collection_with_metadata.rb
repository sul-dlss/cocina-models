# frozen_string_literal: true

module Cocina
  module Models
    # Collection with addition object metadata.
    class CollectionWithMetadata < BaseModel
      attr_accessor :cocinaVersion, :type, :externalIdentifier, :label, :version, :access, :administrative, :description, :identification, :created, :modified, :lock

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
