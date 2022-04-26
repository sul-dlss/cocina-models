# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      # Notifies when a data error is encountered. Notification is performed with Honeybadger.
      class ErrorNotifier
        # In addition, it distinguishes between warnings and errors, even if both are notified the same.
        # The determination of warn / error is currently made by the metadata team.

        # @param [String] druid
        def initialize(druid:)
          @druid = druid
        end

        # Notify for a non-critical data error.
        # @param [String] message
        # @param [Hash<String, String>] context to add to warning context
        def warn(message, _context = {})
          Kernel.warn "[WARN] #{message}"
        end

        # Notify for a critical data error.
        # @param [String] message
        # @param [Hash<String, String>] context to add to error context
        def error(message, _context = {})
          Kernel.warn "[ERROR] #{message}"
        end

        private

        attr_reader :druid
      end
    end
  end
end
