# frozen_string_literal: true

module Cocina
  module Models
    # Domain-defined abstraction of a 'work'. Digital Repository Objects' abstraction is
    # describable for our domain’s purposes, i.e. for management needs within our system.
    class DRO < BaseModel
      attr_accessor :cocinaVersion, :type, :externalIdentifier, :label, :version, :access, :administrative, :description, :identification, :structural, :geographic

      include Validatable

      TYPES = [
        'https://cocina.sul.stanford.edu/models/object',
        'https://cocina.sul.stanford.edu/models/3d',
        'https://cocina.sul.stanford.edu/models/agreement',
        'https://cocina.sul.stanford.edu/models/book',
        'https://cocina.sul.stanford.edu/models/document',
        'https://cocina.sul.stanford.edu/models/geo',
        'https://cocina.sul.stanford.edu/models/image',
        'https://cocina.sul.stanford.edu/models/page',
        'https://cocina.sul.stanford.edu/models/photograph',
        'https://cocina.sul.stanford.edu/models/manuscript',
        'https://cocina.sul.stanford.edu/models/map',
        'https://cocina.sul.stanford.edu/models/media',
        'https://cocina.sul.stanford.edu/models/track',
        'https://cocina.sul.stanford.edu/models/webarchive-binary',
        'https://cocina.sul.stanford.edu/models/webarchive-seed'
      ].freeze
    end
  end
end
