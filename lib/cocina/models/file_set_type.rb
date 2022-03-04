# frozen_string_literal: true

module Cocina
  module Models
    # This vocabulary defines the types of file sets
    class FileSetType
      def self.three_dimensional
        'http://cocina.sul.stanford.edu/models/resources/3d.jsonld'
      end

      def self.attachment
        'http://cocina.sul.stanford.edu/models/resources/attachment.jsonld'
      end

      def self.audio
        'http://cocina.sul.stanford.edu/models/resources/audio.jsonld'
      end

      def self.document
        'http://cocina.sul.stanford.edu/models/resources/document.jsonld'
      end

      def self.file
        'http://cocina.sul.stanford.edu/models/resources/file.jsonld'
      end

      def self.image
        'http://cocina.sul.stanford.edu/models/resources/image.jsonld'
      end

      def self.main_augmented
        'http://cocina.sul.stanford.edu/models/resources/main-augmented.jsonld'
      end

      def self.main_original
        'http://cocina.sul.stanford.edu/models/resources/main-original.jsonld'
      end

      def self.media
        'http://cocina.sul.stanford.edu/models/resources/media.jsonld'
      end

      def self.object
        'http://cocina.sul.stanford.edu/models/resources/object.jsonld'
      end

      def self.page
        'http://cocina.sul.stanford.edu/models/resources/page.jsonld'
      end

      def self.permissions
        'http://cocina.sul.stanford.edu/models/resources/permissions.jsonld'
      end

      def self.preview
        'http://cocina.sul.stanford.edu/models/resources/preview.jsonld'
      end

      def self.supplement
        'http://cocina.sul.stanford.edu/models/resources/supplement.jsonld'
      end

      def self.thumb
        'http://cocina.sul.stanford.edu/models/resources/thumb.jsonld'
      end

      def self.video
        'http://cocina.sul.stanford.edu/models/resources/video.jsonld'
      end
    end
  end
end
