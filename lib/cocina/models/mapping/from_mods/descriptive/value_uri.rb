# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMods
        class Descriptive
          # Sniffs value URIs
          class ValueURI
            SUPPORTED_PREFIXES = [
              'http'
            ].freeze

            def self.sniff(uri, notifier)
              if uri.present? && !uri.starts_with?(*SUPPORTED_PREFIXES)
                notifier.warn('Value URI has unexpected value',
                              { uri: uri })
              end

              uri.presence
            end
          end
        end
      end
    end
  end
end
