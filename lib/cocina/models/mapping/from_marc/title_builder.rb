# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMarc
        # Maps titles
        class TitleBuilder
          # @param [Hash] marc MARC record from FOLIO
          # @param [Cocina::Models::Mapping::ErrorNotifier] notifier
          # @return [Hash] a hash that can be mapped to a cocina model
          def self.build(marc:, notifier:)
            new(marc: marc, notifier: notifier).build
          end

          def initialize(marc:, notifier:)
            @marc = marc
            @notifier = notifier
          end

          def build
            title_fields = %w[245 246 240 130 740]
            unless title_fields.any? { |field| fields.any? { |f| f.key?(field) } }
              notifier.warn('No title fields found')
              return nil
            end

            # Is this a basic title or a title with parts
            basic_title if basic_title?
            # return structured_value(title_field)
          end

          private

          attr_reader :marc, :notifier

          def fields
            marc['fields']
          end

          def basic_title?
            tag = fields.find { |field| field.key?('245') }
            return false unless tag

            subfields = tag.dig('245', 'subfields')
            ind2 = tag.dig('245', 'ind2')
            return false unless ind2 == '0' && subfields.any? { |subfield| subfield.key?('a') }

            true
          end

          def basic_title
            tag = fields.find { |field| field.key?('245') }
            subfields = tag.dig('245', 'subfields')
            title = subfields.find { |subfield| subfield.key?('a') }

            title_value = strip_punctuation(title['a'])
            [{ value: title_value }]
          end

          def strip_punctuation(value)
            # Remove set of punctuation characters at the end of the subfield
            escaped_chars = Regexp.escape(':;/[, ')
            regex = /[#{escaped_chars}]+\z/
            value.gsub(regex, '')
          end
        end
      end
    end
  end
end
