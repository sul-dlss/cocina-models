# frozen_string_literal: true

module Cocina
  module Models
    # This vocabulary defines the types of file sets
    class FileSetType
      def self.three_dimensional
        'https://cocina.sul.stanford.edu/models/resources/3d'
      end

      def self.attachment
        'https://cocina.sul.stanford.edu/models/resources/attachment'
      end

      def self.audio
        'https://cocina.sul.stanford.edu/models/resources/audio'
      end

      def self.document
        'https://cocina.sul.stanford.edu/models/resources/document'
      end

      def self.file
        'https://cocina.sul.stanford.edu/models/resources/file'
      end

      def self.image
        'https://cocina.sul.stanford.edu/models/resources/image'
      end

      def self.main_augmented
        'https://cocina.sul.stanford.edu/models/resources/main-augmented'
      end

      def self.main_original
        'https://cocina.sul.stanford.edu/models/resources/main-original'
      end

      def self.media
        'https://cocina.sul.stanford.edu/models/resources/media'
      end

      def self.object
        'https://cocina.sul.stanford.edu/models/resources/object'
      end

      def self.page
        'https://cocina.sul.stanford.edu/models/resources/page'
      end

      def self.permissions
        'https://cocina.sul.stanford.edu/models/resources/permissions'
      end

      def self.preview
        'https://cocina.sul.stanford.edu/models/resources/preview'
      end

      def self.supplement
        'https://cocina.sul.stanford.edu/models/resources/supplement'
      end

      def self.thumb
        'https://cocina.sul.stanford.edu/models/resources/thumb'
      end

      def self.video
        'https://cocina.sul.stanford.edu/models/resources/video'
      end
    end
  end
end
