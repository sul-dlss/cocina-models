# frozen_string_literal: true

module Cocina
  module Models
    # Domain-defined abstraction of a 'work'. Digital Repository Objects' abstraction is describable for our domain’s purposes, i.e. for management needs within our system.
    class DRO < Struct
      include Validatable

      include Checkable

      TYPES = ['https://cocina.sul.stanford.edu/models/object',
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
               'https://cocina.sul.stanford.edu/models/webarchive-seed'].freeze

      # The version of Cocina with which this object conforms.
      # example: 1.2.3
      attribute :cocinaVersion, CocinaVersion.default(VERSION)
      # The content type of the DRO. Selected from an established set of values.
      attribute :type, Types::Strict::String.enum(*DRO::TYPES)
      # example: druid:bc123df4567
      attribute :externalIdentifier, Druid
      # Primary processing label (can be same as title) for a DRO.
      attribute :label, Types::Strict::String
      # Version for the DRO within SDR.
      attribute :version, Types::Strict::Integer
      attribute(:access, DROAccess.default { DROAccess.new })
      attribute(:administrative, Administrative.default { Administrative.new })
      attribute(:description, Description.default { Description.new })
      attribute(:identification, Identification.default { Identification.new })
      attribute(:structural, DROStructural.default { DROStructural.new })
      attribute? :geographic, Geographic.optional
    end
  end
end
