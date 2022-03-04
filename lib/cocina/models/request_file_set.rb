# frozen_string_literal: true

module Cocina
  module Models
    class RequestFileSet < Struct
      include Checkable

      TYPES = ['https://cocina.sul.stanford.edu/models/resources/audio',
               'https://cocina.sul.stanford.edu/models/resources/attachment',
               'https://cocina.sul.stanford.edu/models/resources/document',
               'https://cocina.sul.stanford.edu/models/resources/file',
               'https://cocina.sul.stanford.edu/models/resources/image',
               'https://cocina.sul.stanford.edu/models/resources/main-augmented',
               'https://cocina.sul.stanford.edu/models/resources/main-original',
               'https://cocina.sul.stanford.edu/models/resources/media',
               'https://cocina.sul.stanford.edu/models/resources/object',
               'https://cocina.sul.stanford.edu/models/resources/page',
               'https://cocina.sul.stanford.edu/models/resources/permissions',
               'https://cocina.sul.stanford.edu/models/resources/preview',
               'https://cocina.sul.stanford.edu/models/resources/supplement',
               'https://cocina.sul.stanford.edu/models/resources/3d',
               'https://cocina.sul.stanford.edu/models/resources/thumb',
               'https://cocina.sul.stanford.edu/models/resources/video'].freeze

      attribute :type, Types::Strict::String.enum(*RequestFileSet::TYPES)
      attribute :label, Types::Strict::String
      attribute :version, Types::Strict::Integer
      attribute(:structural, RequestFileSetStructural.default { RequestFileSetStructural.new })
    end
  end
end
