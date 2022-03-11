# frozen_string_literal: true

module Cocina
  module Models
    # Rights description builder for items
    class DroRightsDescriptionBuilder < RightsDescriptionBuilder
      # @param [Cocina::Models::DRO] cocina_item

      # This overrides the superclass
      # @return [Cocina::Models::DROAccess]
      def object_access
        @object_access ||= cocina.access
      end

      private

      def object_level_access
        super + access_level_from_files.uniq.map { |str| "#{str} (file)" }
      end

      def access_level_from_files
        # dark access doesn't permit any file access
        return [] if object_access.view == 'dark'

        file_access_nodes.reject { |fa| same_as_object_access?(fa) }.flat_map do |fa|
          file_access_from_file(fa)
        end
      end

      # rubocop:disable Metrics/MethodLength
      def file_access_from_file(file_access)
        basic_access = if file_access[:view] == 'location-based'
                         "location: #{file_access[:location]}"
                       else
                         file_access[:view]
                       end

        return [basic_access] if file_access[:view] == file_access[:download]

        basic_access += ' (no-download)' if file_access[:view] != 'dark'

        case file_access[:download]
        when 'stanford'
          [basic_access, 'stanford']
        when 'location-based'
          # Here we're using location to mean download location.
          [basic_access, "location: #{file_access[:location]}"]
        else
          [basic_access]
        end
      end
      # rubocop:enable Metrics/MethodLength

      def same_as_object_access?(file_access)
        (file_access[:view] == object_access.view && file_access[:download] == object_access.download) ||
          (object_access.view == 'citation-only' && file_access[:view] == 'dark')
      end

      def file_access_nodes
        Array(cocina.structural.contains)
          .flat_map { |fs| Array(fs.structural.contains) }
          .map { |file| file.access.to_h }
          .uniq
      end
    end
  end
end
