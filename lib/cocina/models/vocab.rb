# frozen_string_literal: true

module Cocina
  module Models
    # A digital repository object.  See http://sul-dlss.github.io/cocina-models/maps/DRO.json
    class Vocab
      def self.three_dimensional
        'http://cocina.sul.stanford.edu/models/3d.jsonld'
      end

      def self.admin_policy
        'http://cocina.sul.stanford.edu/models/admin_policy.jsonld'
      end

      def self.agreement
        'http://cocina.sul.stanford.edu/models/agreement.jsonld'
      end

      def self.book
        'http://cocina.sul.stanford.edu/models/book.jsonld'
      end

      def self.collection
        'http://cocina.sul.stanford.edu/models/collection.jsonld'
      end

      def self.curated_collection
        'http://cocina.sul.stanford.edu/models/curated-collection.jsonld'
      end

      def self.document
        'http://cocina.sul.stanford.edu/models/document.jsonld'
      end

      def self.exhibit
        'http://cocina.sul.stanford.edu/models/exhibit.jsonld'
      end

      def self.file
        'http://cocina.sul.stanford.edu/models/file.jsonld'
      end

      def self.geo
        'http://cocina.sul.stanford.edu/models/geo.jsonld'
      end

      def self.image
        'http://cocina.sul.stanford.edu/models/image.jsonld'
      end

      def self.manuscript
        'http://cocina.sul.stanford.edu/models/manuscript.jsonld'
      end

      def self.map
        'http://cocina.sul.stanford.edu/models/map.jsonld'
      end

      def self.media
        'http://cocina.sul.stanford.edu/models/media.jsonld'
      end

      def self.object
        'http://cocina.sul.stanford.edu/models/object.jsonld'
      end

      def self.page
        'http://cocina.sul.stanford.edu/models/page.jsonld'
      end

      def self.photograph
        'http://cocina.sul.stanford.edu/models/photograph.jsonld'
      end

      def self.series
        'http://cocina.sul.stanford.edu/models/series.jsonld'
      end

      def self.track
        'http://cocina.sul.stanford.edu/models/track.jsonld'
      end

      def self.user_collection
        'http://cocina.sul.stanford.edu/models/user-collection.jsonld'
      end

      def self.webarchive_binary
        'http://cocina.sul.stanford.edu/models/webarchive-binary.jsonld'
      end

      def self.webarchive_seed
        'http://cocina.sul.stanford.edu/models/webarchive-seed.jsonld'
      end

      class Resources
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
end
