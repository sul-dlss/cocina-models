# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMarc
        # Utilities for MARC manipulation
        class Util
          def self.strip_punctuation(value)
            # Remove set of punctuation characters at the end of the subfield
            escaped_chars = Regexp.escape(':;/[, ')
            regex = /[#{escaped_chars}]+\z/
            value.gsub(regex, '')
          end

          def self.linked_field(marc, field)
            pointer = field.subfields.find { |subfield| subfield.code == '6' }
            return unless pointer

            field_id, index = pointer.value.split('-')
            marc.fields(field_id)[index.to_i - 1]
          end
        end
      end
    end
  end
end
