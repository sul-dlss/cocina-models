# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMarc
        # Maps form information from MARC records to Cocina models.
        class Form
          # @see #initialize
          # @see #build
          def self.build(...)
            new(...).build
          end

          # @param [MARC::Record] marc MARC record from FOLIO
          def initialize(marc:)
            @marc = marc
          end

          # @return [Array<Hash>] an array of form hashes
          def build
            [
              [build_simple_form(marc['300'], %w[a b c e f g 3])],
              build_physical_medium(marc['340']),
              build_sound_characteristics(marc['344']),
              build_organization_and_arrangement(marc['351']),
              build_genre_form(marc['655']),
              build_cartographic(marc['255']),
              marc.fields.select { it.tag == '336' }.map { build_content_type(it) },
              build_dataset_genre

            ].flatten.compact
          end

          PHYSICAL_MEDIUM_FIELDS = {
            'a' => 'Material base and configuration',
            'b' => 'Dimensions',
            'c' => 'Materials applied to surface',
            'd' => 'Information recording technique',
            'i' => 'Technical specifications of medium',
            'j' => 'Generation'
          }.freeze

          SOUND_CHARACTERISTICS = {
            'a' => 'Type of recording',
            'b' => 'Recording medium',
            'c' => 'Playing speed',
            'd' => 'Groove characteristic',
            'e' => 'Track configuration',
            'f' => 'Tape configuration',
            'g' => 'Configuration of playback channels',
            'h' => 'Special playback characteristics'
          }.freeze

          private

          def build_simple_form(field, codes)
            return unless field

            codes = Array(codes)
            values = []
            field.subfields.each do |sf|
              next if sf.code == '6'

              values << sf.value if codes.include?(sf.code)
            end
            return nil if values.empty?

            { value: values.join(' ') }
          end

          def build_physical_medium(field)
            return unless field

            field.subfields.map do |sf|
              value = PHYSICAL_MEDIUM_FIELDS[sf.code]
              next unless value

              { note: [{ value: sf.value, displayLabel: value }] }
            end
          end

          def build_sound_characteristics(field)
            return unless field

            field.subfields.map do |sf|
              value = SOUND_CHARACTERISTICS[sf.code]
              next unless value

              { note: [{ value: sf.value, displayLabel: value }] }
            end
          end

          def build_organization_and_arrangement(field)
            return unless field

            { note: [{ value: [field['3'], field['c'], field['a'], field['b']].join(' '), type: 'arrangement' }] }
          end

          def build_genre_form(field)
            return unless field

            {
              value: field['a'],
              type: 'genre'
            }
          end

          def build_cartographic(field)
            return unless field

            vals = []
            vals << { value: field['a'], type: 'map scale' } if field['a']
            vals << { value: field['b'], type: 'map projection' } if field['b']
            vals.compact
          end

          def build_content_type(field)
            return unless field

            { value: field['a'], type: 'genre' }
          end

          def build_dataset_genre
            return unless marc['008'] && marc['008'].value[26] && marc.leader[6] == 'm'

            { value: 'dataset', type: 'genre' }
          end

          attr_reader :marc
        end
      end
    end
  end
end
