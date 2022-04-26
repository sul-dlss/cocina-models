# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMods
        class Descriptive
          # Normalizes Authorities
          class Authority
            NORMALIZE_AUTHORITY_URIS = [
              'http://id.loc.gov/authorities/names',
              'http://id.loc.gov/authorities/subjects',
              'http://id.loc.gov/vocabulary/relators',
              'http://id.loc.gov/vocabulary/countries',
              'http://id.loc.gov/authorities/genreForms',
              'http://id.loc.gov/vocabulary/descriptionConventions'
            ].freeze

            def self.normalize_uri(uri)
              return "#{uri}/" if NORMALIZE_AUTHORITY_URIS.include?(uri)

              uri.presence
            end

            def self.normalize_code(code, notifier)
              if code == 'lcnaf'
                notifier.warn('lcnaf authority code')
                return 'naf'
              end

              if code == 'tgm'
                notifier.warn('tgm authority code (should be lctgm)')
                return 'lctgm'
              end

              if code == '#N/A'
                notifier.warn('"#N/A" authority code')
                return nil
              end

              if code == 'marcountry'
                notifier.warn('marcountry authority code (should be marccountry)')
                return 'marccountry'
              end

              code.presence
            end
          end
        end
      end
    end
  end
end
