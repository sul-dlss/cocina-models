# frozen_string_literal: true

module Cocina
  module Models
    # RightsDescriptionBuilder
    class RightsDescriptionBuilder
      # @param [Cocina::Models::AdminPolicy, Cocina::Models::DRO] cocina_object
      def self.build(cocina_object)
        new(cocina_object).build
      end

      def initialize(cocina_object)
        @cocina = cocina_object
      end

      # This is set up to work for APOs, but this method is to be overridden on sub classes
      # @return [Cocina::Models::AdminPolicyDefaultAccess]
      def object_access
        @object_access ||= cocina.administrative.accessTemplate
      end

      def build
        return 'controlled digital lending' if object_access.controlledDigitalLending

        return ['dark'] if object_access.view == 'dark'

        object_level_access
      end

      private

      attr_reader :cocina

      # rubocop:disable Metrics/MethodLength
      def object_level_access
        case object_access.view
        when 'citation-only'
          ['citation']
        when 'world'
          world_object_access
        when 'location-based'
          case object_access.download
          when 'none'
            ["location: #{object_access.location} (no-download)"]
          else
            ["location: #{object_access.location}"]
          end
        when 'stanford'
          stanford_object_access
        end
      end
      # rubocop:enable Metrics/MethodLength

      def stanford_object_access
        case object_access.download
        when 'none'
          ['stanford (no-download)']
        when 'location-based'
          # this is an odd case we might want to move away from. See https://github.com/sul-dlss/cocina-models/issues/258
          ['stanford (no-download)', "location: #{object_access.location}"]
        else
          ['stanford']
        end
      end

      def world_object_access
        case object_access.download
        when 'stanford'
          ['stanford', 'world (no-download)']
        when 'none'
          ['world (no-download)']
        when 'world'
          ['world']
        when 'location-based'
          # this is an odd case we might want to move away from. See https://github.com/sul-dlss/cocina-models/issues/258
          ['world (no-download)', "location: #{object_access.location}"]
        end
      end
    end
  end
end
