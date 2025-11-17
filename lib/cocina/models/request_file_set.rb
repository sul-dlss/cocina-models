# frozen_string_literal: true

module Cocina
  module Models
    class RequestFileSet < BaseModel
      attr_accessor :type, :label, :version, :structural

      TYPES = [
        'https://cocina.sul.stanford.edu/models/resources/audio',
        'https://cocina.sul.stanford.edu/models/resources/attachment',
        'https://cocina.sul.stanford.edu/models/resources/document',
        'https://cocina.sul.stanford.edu/models/resources/file',
        'https://cocina.sul.stanford.edu/models/resources/image',
        'https://cocina.sul.stanford.edu/models/resources/media',
        'https://cocina.sul.stanford.edu/models/resources/object',
        'https://cocina.sul.stanford.edu/models/resources/page',
        'https://cocina.sul.stanford.edu/models/resources/preview',
        'https://cocina.sul.stanford.edu/models/resources/3d',
        'https://cocina.sul.stanford.edu/models/resources/thumb',
        'https://cocina.sul.stanford.edu/models/resources/video'
      ].freeze
    end
  end
end
