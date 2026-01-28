# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMarc
        # Maps titles
        class TitleBuilder
          # @see #initialize
          # @see #build
          def self.build(...)
            new(...).build
          end

          # @param [MARC::Record] marc MARC record from FOLIO
          # @param [Cocina::Models::Mapping::ErrorNotifier] notifier
          def initialize(marc:, notifier:)
            @marc = marc
            @notifier = notifier
          end

          # @return [Hash] a hash that can be mapped to a cocina model
          def build
            title_fields = %w[245 246 240 130 740]
            unless title_fields.any? { |code| marc[code]&.subfields&.any? }
              notifier.warn('No title fields found')
              return nil
            end

            # Return a basic title
            # TODO: implement structured values
            basic_title if basic_title?
          end

          private

          attr_reader :marc, :notifier

          delegate :fields, to: :marc

          def basic_title?
            tag = marc['245']
            tag && tag.indicator2 == '0' && tag.subfields.any? { |subfield| subfield.code == 'a' }
          end

          def basic_title
            tag = marc['245']

            title = tag.subfields.find { |subfield| subfield.code == 'a' }
            title_value = strip_punctuation(title.value)
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
