# frozen_string_literal: true

module Cocina
  module Models
    # Rights description builder for apos and the subclass of DroRightsDescriptionBuilder
    module RightsDescriptionBuilder
      # @param [Cocina::Models::AdminPolicy, Cocina::Models::DRO] cocina_object
      # def self.build(cocina_object)
      #   new(cocina_object).build
      # end

      # def initialize(cocina_object)
      #   @cocina = cocina_object
      # end

      # This is set up to work for APOs, but this method is to be overridden on sub classes
      # @return [Cocina::Models::AdminPolicyDefaultAccess]
      def object_access
        @cocina_access ||= administrative.accessTemplate

        build
      end

      private

      attr_reader :cocina_access

      def build
        return 'controlled digital lending' if cocina_access.controlledDigitalLending

        return ['dark'] if cocina_access.view == 'dark'

        object_level_access
      end

      def object_level_access
        case cocina_access.view
        when 'citation-only'
          ['citation']
        when 'world'
          world_object_access
        when 'location-based'
          location_based_download
        when 'stanford'
          stanford_object_access
        end
      end

      def location_based_download
        return ["location: #{cocina_access.location} (no-download)"] if cocina_access.download == 'none'

        ["location: #{cocina_access.location}"]
      end

      def stanford_object_access
        case cocina_access.download
        when 'none'
          ['stanford (no-download)']
        when 'location-based'
          # this is an odd case we might want to move away from. See https://github.com/sul-dlss/cocina-models/issues/258
          ['stanford (no-download)', "location: #{cocina_access.location}"]
        else
          ['stanford']
        end
      end

      def world_object_access
        case cocina_access.download
        when 'stanford'
          ['stanford', 'world (no-download)']
        when 'none'
          ['world (no-download)']
        when 'world'
          ['world']
        when 'location-based'
          # this is an odd case we might want to move away from. See https://github.com/sul-dlss/cocina-models/issues/258
          ['world (no-download)', "location: #{cocina_access.location}"]
        end
      end
    end
  end
end
