# frozen_string_literal: true

module Cocina
  module Models
    class FileSet < Struct
      include Checkable

      TYPES = ['http://cocina.sul.stanford.edu/models/resources/audio.jsonld',
               'http://cocina.sul.stanford.edu/models/resources/attachment.jsonld',
               'http://cocina.sul.stanford.edu/models/resources/document.jsonld',
               'http://cocina.sul.stanford.edu/models/resources/file.jsonld',
               'http://cocina.sul.stanford.edu/models/resources/image.jsonld',
               'http://cocina.sul.stanford.edu/models/resources/main-augmented.jsonld',
               'http://cocina.sul.stanford.edu/models/resources/main-original.jsonld',
               'http://cocina.sul.stanford.edu/models/resources/media.jsonld',
               'http://cocina.sul.stanford.edu/models/resources/object.jsonld',
               'http://cocina.sul.stanford.edu/models/resources/page.jsonld',
               'http://cocina.sul.stanford.edu/models/resources/permissions.jsonld',
               'http://cocina.sul.stanford.edu/models/resources/preview.jsonld',
               'http://cocina.sul.stanford.edu/models/resources/supplement.jsonld',
               'http://cocina.sul.stanford.edu/models/resources/3d.jsonld',
               'http://cocina.sul.stanford.edu/models/resources/thumb.jsonld',
               'http://cocina.sul.stanford.edu/models/resources/video.jsonld'].freeze

      # The content type of the Fileset.
      attribute :type, Types::Strict::String.enum(*FileSet::TYPES)
      attribute :externalIdentifier, Types::Strict::String
      # Primary processing label for a Fileset.
      attribute :label, Types::Strict::String
      # Version for the Fileset within SDR.
      attribute :version, Types::Strict::Integer
      attribute :structural, FileSetStructural.optional.meta(omittable: true)
    end
  end
end
