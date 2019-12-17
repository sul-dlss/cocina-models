# frozen_string_literal: true

module Cocina
  module Models
    # A digital repository object.  See http://sul-dlss.github.io/cocina-models/maps/DRO.json
    class Vocab
      ROOT = 'http://cocina.sul.stanford.edu/models/'

      ### Object types ###

      # This is the most generic type
      def self.object
        "#{ROOT}object.jsonld"
      end

      def self.agreement
        "#{ROOT}agreement.jsonld"
      end

      def self.document
        "#{ROOT}document.jsonld"
      end

      def self.geo
        "#{ROOT}geo.jsonld"
      end

      def self.page
        "#{ROOT}page.jsonld"
      end

      def self.photograph
        "#{ROOT}photograph.jsonld"
      end

      def self.manuscript
        "#{ROOT}manuscript.jsonld"
      end

      def self.map
        "#{ROOT}map.jsonld"
      end

      def self.track
        "#{ROOT}track.jsonld"
      end

      def self.webarchive_binary
        "#{ROOT}webarchive-binary.jsonld"
      end

      def self.webarchive_seed
        "#{ROOT}webarchive-seed.jsonld"
      end

      # For time based media
      def self.media
        "#{ROOT}media.jsonld"
      end

      def self.image
        "#{ROOT}image.jsonld"
      end

      def self.book
        "#{ROOT}book.jsonld"
      end

      def self.three_dimensional
        "#{ROOT}3d.jsonld"
      end

      ### File type ###

      def self.file
        "#{ROOT}file.jsonld"
      end

      ### Fileset type ###

      def self.fileset
        "#{ROOT}fileset.jsonld"
      end

      ### Collection types ###

      # The most generic type of collection
      def self.collection
        "#{ROOT}collection.jsonld"
      end

      def self.curated_collection
        "#{ROOT}curated-collection.jsonld"
      end

      def self.user_collection
        "#{ROOT}user-collection.jsonld"
      end

      def self.exhibit
        "#{ROOT}exhibit.jsonld"
      end

      def self.series
        "#{ROOT}series.jsonld"
      end

      ### Admin Policy type ###

      def self.admin_policy
        "#{ROOT}admin_policy.jsonld"
      end
    end
  end
end
