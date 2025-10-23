# frozen_string_literal: true

module Cocina
  module Models
    # A request to create a DRO.  This has the same general structure as a DRO but doesn't
    # have externalIdentifier and doesn't require the access subschema. If no access subschema
    # is provided, these values will be inherited from the AdminPolicy.
    class RequestDRO < Struct
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
      attribute :type, Types::Strict::String.enum(*RequestDRO::TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer.default(1).enum(1)
      attribute? :access, DROAccess.optional
      attribute(:administrative, RequestAdministrative.default { RequestAdministrative.new })
      attribute? :description, RequestDescription.optional
      attribute(:identification, RequestIdentification.default { RequestIdentification.new })
      attribute? :structural, RequestDROStructural.optional
      attribute? :geographic, Geographic.optional
    end
  end
end
