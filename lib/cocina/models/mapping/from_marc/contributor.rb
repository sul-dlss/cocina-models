# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMarc
        # Maps contributor information from MARC records to Cocina models.
        class Contributor
          # @see #initialize
          # @see #build
          def self.build(...)
            new(...).build
          end

          # @param [MARC::Record] marc MARC record from FOLIO
          def initialize(marc:)
            @marc = marc
          end

          # @return [Array<Hash>] an array of contributor hashes
          def build
            linked_100_field = Util.linked_field(marc, marc['100']) if marc['100']
            linked_700_field = Util.linked_field(marc, marc['700']) if marc['700']

            [
              build_personal(marc['100'], primary: true),
              build_personal(linked_100_field),
              build_corporate(marc['110'], primary: true),
              build_event(marc['111'], primary: true),
              build_personal(marc['700']),
              build_personal(linked_700_field),
              build_corporate(marc['710']),
              build_event(marc['711']),
              build_personal(marc['720'])

            ].compact
          end

          private

          def build_personal(field, primary: false)
            return unless field

            name_type = case field.indicator1
                        when '1', '2'
                          'person'
                        when '3'
                          'family'
                        end
            contributor = { type: name_type }.compact
            contributor[:name] = [build_personal_name(field)]
            contributor[:role] = build_roles(field)
            id = build_id(field).first
            contributor[:identifier] = [{ uri: id, type: 'ORCID' }.compact_blank] if id&.start_with? 'https://orcid.org/'
            contributor[:status] = 'primary' if primary
            contributor.compact_blank
          end

          def build_personal_name(field)
            return unless field

            name = Util.strip_punctuation(field.subfields.select { |subfield| %w[a c q d].include? subfield.code }.map(&:value).join(' '))
            { value: name }
          end

          def build_id(field)
            field.subfields.select { |subfield| %w[1].include? subfield.code }.map(&:value)
          end

          def build_roles(field, code: 'e')
            expanded = field.subfields.select { |sf| sf.code == '4' }.map { |role| { value: MARC_RELATORS[role.value] }.compact_blank }

            (field.subfields.select { |sf| sf.code == code }.map { |role| { value: role.value.sub(/.$/, '') } } +
              expanded).uniq.compact_blank
          end

          def build_corporate(field, primary: false)
            return unless field

            contributor = { type: 'organization' }
            name = field.subfields.select { |subfield| %w[a b q d].include? subfield.code }.map(&:value).join(' ')
            contributor[:name] = [{ value: name }]
            id = build_id(field).first
            contributor[:identifier] = [{ uri: id }] if id

            contributor[:status] = 'primary' if primary
            contributor
          end

          def build_event(field, primary: false)
            return unless field

            contributor = { type: 'event' }
            name = field.subfields.select { |subfield| %w[a n d c].include? subfield.code }.map(&:value).join(' ')
            contributor[:name] = [{ value: name }]
            roles = build_roles(field, code: 'j')
            contributor[:role] = roles if roles.present?
            contributor[:status] = 'primary' if primary
            contributor
          end

          attr_reader :marc
        end
      end
    end
  end
end
