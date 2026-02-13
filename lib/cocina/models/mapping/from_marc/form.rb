# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMarc
        # Maps form information from MARC records to Cocina models.
        class Form # rubocop:disable Metrics/ClassLength
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
          def build # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
            [
              [build_simple_form(marc['300'], %w[a b c e f g 3])],
              build_physical_medium(marc['340']),
              build_sound_characteristics(marc['344']),
              build_organization_and_arrangement(marc['351']),
              build_genre_form(marc['655']),
              build_cartographic(marc['255']),
              marc.fields.select { it.tag == '336' }.map { build_content_type(it) },
              build_resource_types,
              build_type_from006and008,
              build_dataset_genre,
              build_blu_ray(marc['538']),
              build_searchworks_manuscript(marc['245']),
              build_searchworks_video(marc['245']),
              build_searchworks_image245(marc['245']),
              build_searchworks_image,
              build_searchworks_piano_roll(marc['338'])

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

          def build_searchworks_image245(field) # rubocop:disable Metrics/PerceivedComplexity
            return unless field && field['h']

            image_terms = [
              'art original', 'digital graphic', 'slide', 'slides', 'chart', 'art reproduction', 'graphic', 'technical drawing', 'flash card', 'transparency', 'activity card', 'picture', 'graphic/digital graphic', 'diapositives'
            ]
            return sw_type('Image') if image_terms.any? { |term| field['h'].match?(/#{term}/i) }

            control007_byte0 = marc['007']&.value&.[](0)
            sw_type('Image') if field['h'].match?(/kit/) && %w[k r].include?(control007_byte0)
          end

          def build_searchworks_image # rubocop:disable Metrics/MethodLength
            control007 = marc['007']
            return unless control007

            control007_byte0 = control007.value[0]
            control007_byte1 = control007.value[1]
            case control007_byte0
            when 'k'
              if %w[g h r v].include?(control007_byte1)
                sw_type('Image')
                sw_type('Image|Photo')
              elsif control007_byte1 == 'k'
                sw_type('Image')
                sw_type('Image|Poster')
              end
            when 'g'
              if control007_byte1 == 's'
                sw_type('Image')
                sw_type('Image|Slide')
              end
            end
          end

          def build_searchworks_manuscript(field)
            return unless field && %w[manuscript manuscript/digital].include?(field['h'])

            sw_type('Archive / Manuscript')
          end

          def build_searchworks_video(field)
            return unless field && field['n']

            video_terms = ['videorecording', 'video recording', 'videorecordings', 'video recordings', 'motion picture', 'filmstrip', 'videodisc', 'videocassette']
            return unless video_terms.any? { |term| field['n'].match?(/#{term}/i) }

            sw_type('Video/Film')
          end

          def build_searchworks_piano_roll(field)
            return unless field && field['a']

            piano_roll_terms = ['piano roll', 'organ roll', 'audio roll']

            return unless piano_roll_terms.any? { |term| field['a'].match?(/#{term}/i) }

            sw_type('Sound recording') + sw_type('Sound recording|Piano/Organ roll')
          end

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

          def build_blu_ray(field)
            return unless field && field['a'] && ['Bluray', 'Blu-ray', 'Blu ray'].any? { |term| field['a'].match?(/#{term}/i) }

            sw_type('Video/Film') + sw_type('Video/Film|Blu-ray')
          end

          def build_cartographic(field)
            return unless field

            vals = []
            vals << { value: field['a'], type: 'map scale' } if field['a']
            vals << { value: field['b'], type: 'map projection' } if field['b']
            vals.compact
          end

          def leader07
            @leader07 ||= marc.leader&.[](7)
          end

          def leader06
            @leader06 ||= marc.leader&.[](6)
          end

          def control008_byte26
            @control008_byte26 ||= marc['008']&.value&.[](26)
          end

          def build_content_type(field)
            return unless field

            { value: field['a'], type: 'genre' }
          end

          def build_dataset_genre
            return unless control008_byte26 == 'a' && leader06 == 'm'

            { value: 'dataset', type: 'genre', source: { code: 'local' } }
          end

          def sw_type(value)
            [{ value:, type: 'resource type', source: { value: 'SearchWorks resource types'} }]
          end

          def mods_resource_type(value)
            { value:, type: 'resource type', source: { value: 'MODS resource types' } }
          end

          def lc_resource_type(value)
            { value:, type: 'resource type', source: { value: 'LC Resource Types Scheme' } }
          end

          def build_resource_types # rubocop:disable Metrics/CyclomaticComplexity,Metrics/MethodLength
            return unless marc.leader

            if leader07 == 'c'
              results = build_collection_resource_type
              results += sw_type('Archive / Manuscript') if leader06 == 'a'
              return results
            end

            case leader06
            when 'a'
              build_text_resource_type
            when 'c'
              build_notated_music_resource_type
            when 'd'
              build_manuscript_notated_music_resource_type + sw_type('Archive / Manuscript')
            when 'e'
              build_cartographic_resource_type
            when 'f'
              build_manuscript_cartographic_resource_type + sw_type('Archive / Manuscript')
            when 'g'
              build_moving_image_resource_type
            when 'i'
              build_sound_nonmusical_resource_type
            when 'j'
              build_sound_musical_resource_type
            when 'k'
              build_still_image_resource_type
            when 'm'
              build_software_multimedia_resource_type
            when 'p'
              build_manuscript_mixed_material_resource_type
            when 'r'
              build_three_dimensional_object_resource_type
            when 't'
              build_manuscript_text_resource_type
            end
          end

          def build_type_from006and008 # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
            result = []
            control008_byte21 = marc['008']&.value&.[](21)
            control006_byte0 = marc['006']&.value&.[](0)
            control006_byte4 = marc['006']&.value&.[](4)

            result << sw_type('Book') if (leader07 == 's' && control008_byte21 == 'm') || (control006_byte0 == 's' && control006_byte4 == 'm')
            result << sw_type('Database') if (leader07 == 's' && control008_byte21 == 'd') || (control006_byte0 == 's' && control006_byte4 == 'd')
            result
          end

          def build_collection_resource_type
            [
              mods_resource_type('collection'),
              lc_resource_type('Collection')
            ]
          end

          def build_text_resource_type
            [
              mods_resource_type('text'),
              lc_resource_type('Text')
            ].tap do |result|
              result << sw_type('Book') if %w[a m].include?(leader07)
            end
          end

          def build_notated_music_resource_type
            [
              mods_resource_type('notated music'),
              lc_resource_type('Notated music')
            ]
          end

          def build_manuscript_notated_music_resource_type
            [
              mods_resource_type('manuscript'),
              mods_resource_type('notated music'),
              lc_resource_type('Manuscript'),
              lc_resource_type('Notated music')
            ]
          end

          def build_cartographic_resource_type
            [
              mods_resource_type('cartographic'),
              lc_resource_type('Cartographic')
            ]
          end

          def build_manuscript_cartographic_resource_type
            [
              mods_resource_type('manuscript'),
              mods_resource_type('cartographic'),
              lc_resource_type('Manuscript'),
              lc_resource_type('Cartographic')
            ]
          end

          def build_moving_image_resource_type
            base = [
              mods_resource_type('moving image'),
              lc_resource_type('Moving image')
            ]
            control008_byte33 = marc['008']&.value&.[](33)
            base << sw_type('Image') if /[aciklnopst 0-9|]/.match?(control008_byte33)
            base
          end

          def build_sound_nonmusical_resource_type
            [
              mods_resource_type('sound recording-nonmusical'),
              lc_resource_type('Audio')
            ]
          end

          def build_sound_musical_resource_type
            [
              mods_resource_type('sound recording-musical'),
              lc_resource_type('Audio')
            ]
          end

          def build_still_image_resource_type
            base = [
              mods_resource_type('still image'),
              lc_resource_type('Still image')
            ]
            control008_byte33 = marc['008']&.value&.[](33)
            base << sw_type('Image') if /[aciklnopst 0-9|]/.match?(control008_byte33)
            base
          end

          def build_software_multimedia_resource_type # rubocop:disable Metrics/MethodLength
            base = [
              mods_resource_type('software, multimedia')
            ]

            if control008_byte26 == 'a'
              base << lc_resource_type('Dataset')
              base << sw_type('Dataset')
            else
              base << lc_resource_type('Digital')
            end

            if control008_byte26 == 'j'
              base << lc_resource_type('Database')
              base << sw_type('Database')
            end

            base << (sw_type('Software/Multimedia') unless %w[a g j].include?(control008_byte26))

            base
          end

          def build_manuscript_mixed_material_resource_type
            [
              mods_resource_type('manuscript'),
              mods_resource_type('mixed material'),
              lc_resource_type('Manuscript'),
              lc_resource_type('Mixed material')
            ] + sw_type('Archive / Manuscript')
          end

          def build_three_dimensional_object_resource_type
            [
              mods_resource_type('three dimensional object'),
              lc_resource_type('Artifact')
            ]
          end

          def build_manuscript_text_resource_type
            [
              mods_resource_type('manuscript'),
              mods_resource_type('text'),
              lc_resource_type('Manuscript'),
              lc_resource_type('Text')
            ] + sw_type('Archive / Manuscript').tap do |result|
              result << sw_type('Book') if %w[a m].include?(leader07)
            end
          end

          attr_reader :marc
        end
      end
    end
  end
end
