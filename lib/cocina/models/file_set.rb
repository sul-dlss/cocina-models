# frozen_string_literal: true

module Cocina
  module Models
    # Relevant groupings of Files. Also called a File Grouping.
    class FileSet < Struct
      include Checkable

      TYPES = ['https://cocina.sul.stanford.edu/models/resources/audio',
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
               'https://cocina.sul.stanford.edu/models/resources/video'].freeze

      # The content type of the Fileset.
      attribute :type, Types::Strict::String.enum(*FileSet::TYPES)
      attribute :externalIdentifier, Types::Strict::String
      # Primary processing label for a Fileset.
      attribute :label, Types::Strict::String
      # Version for the Fileset within SDR.
      attribute :version, Types::Strict::Integer
      # Structural metadata
      attribute(:structural, FileSetStructural.default { FileSetStructural.new })
    end
  end
end
