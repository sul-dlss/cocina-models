# frozen_string_literal: true

module Cocina
  module Models
    class RequestFileSet < Struct
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

      attribute :type, Types::Strict::String.enum(*RequestFileSet::TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer
      attribute(:structural, RequestFileSetStructural.default { RequestFileSetStructural.new })
    end
  end
end
