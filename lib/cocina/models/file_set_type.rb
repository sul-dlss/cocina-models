# frozen_string_literal: true

module Cocina
  module Models
    # This vocabulary defines the types of file sets
    class FileSetType < Vocabulary('https://cocina.sul.stanford.edu/models/resources/')
      property :'3d', method_name: :three_dimensional
      property :attachment
      property :audio
      property :document
      property :file
      property :image
      property :media
      property :object
      property :page
      property :preview
      property :thumb
      property :video
    end
  end
end
