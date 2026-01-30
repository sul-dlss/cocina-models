# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMarc
        # Maps language information from MARC records to Cocina models.
        class Language
          # @see #initialize
          # @see #build
          def self.build(...)
            new(...).build
          end

          # @param [MARC::Record] marc MARC record from FOLIO
          def initialize(marc:)
            @marc = marc
          end

          # 008/35-37, 041 $a, $b, $d, $e, $f, $g, $h, $j
          # @return [Array<Hash>] an array of language hashes
          def build
            languages = (lang_from008 + lang_from041).compact.uniq

            languages.map { |code| { code: code } }
          end

          private

          def lang_from041
            return [] unless marc['041']

            marc['041'].subfields.map do |subfield|
              subfield.value if %w[a b d e f g h j].include?(subfield.code)
            end
          end

          def lang_from008
            return [] unless marc['008']

            [marc['008'].value[35..37]]
          end

          attr_reader :marc
        end
      end
    end
  end
end
