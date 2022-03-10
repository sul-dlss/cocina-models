# frozen_string_literal: true

module Cocina
  module Models
    class DROWithMetadata < Struct
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
      attribute :cocinaVersion, Types::Strict::String.default(Cocina::Models::VERSION)
      # The content type of the DRO. Selected from an established set of values.
      attribute :type, Types::Strict::String.enum(*DROWithMetadata::TYPES)
      # example: druid:bc123df4567
      attribute :externalIdentifier, Types::Strict::String
      # Primary processing label (can be same as title) for a DRO.
      attribute :label, Types::Strict::String
      # Version for the DRO within SDR.
      attribute :version, Types::Strict::Integer
      attribute(:access, DROAccess.default { DROAccess.new })
      attribute(:administrative, Administrative.default { Administrative.new })
      attribute(:description, Description.default { Description.new })
      attribute :identification, Identification.optional.meta(omittable: true)
      attribute :structural, DROStructural.optional.meta(omittable: true)
      attribute :geographic, Geographic.optional.meta(omittable: true)
      # When the object was created.
      attribute :created, Types::Params::DateTime
      # When the object was modified.
      attribute :modified, Types::Params::DateTime
      # Key for optimistic locking. The contents of the key is not specified.
      attribute :lock, Types::Strict::String
    end
  end
end
