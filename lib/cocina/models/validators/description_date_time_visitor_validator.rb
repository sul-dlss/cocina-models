# frozen_string_literal: true

require 'edtf'

module Cocina
  module Models
    module Validators
      # Validates that dates of known types are type-valid using the visitor pattern.
      class DescriptionDateTimeVisitorValidator < BaseDescriptionVisitorValidator
        VALIDATABLE_TYPES = %w[edtf iso8601 w3cdtf].freeze

        def visit_hash(hash:, path:) # rubocop:disable Metrics/CyclomaticComplexity
          # Only dates nested under a `date` key are subject to validation.
          # For example, event.date is in scope but event.note is not.
          return unless in_date_path?(path)

          # A hash with a validatable encoding.code "owns" the encoding for its
          # entire subtree.  For example, the outer hash below owns iso8601 for
          # both structuredValue children even though those children carry no
          # encoding themselves:
          #
          #   date: [{
          #     structuredValue: [
          #       { value: '1996', type: 'start' },
          #       { value: '1998', type: 'end' }
          #     ],
          #     encoding: { code: 'iso8601' }   # ← registered at path [:date, 0]
          #   }]
          #
          # We record the path before visiting children because
          # CompositeDescriptionValidator calls visit_hash on a parent before
          # recursing into its children, so the encoding is always registered
          # before any child value hashes are visited.
          code = hash.dig(:encoding, :code)
          encoding_paths[path.dup] = code if code && VALIDATABLE_TYPES.include?(code)

          value = hash[:value]
          return unless value.is_a?(String)

          # Resolve which encoding governs this value by finding the longest
          # registered encoding path that is a prefix of the current path.
          # Longest-prefix wins so that a more-specific inner encoding overrides
          # a less-specific outer one.  For example, given:
          #
          #   date: [{
          #     parallelValue: [
          #       { value: '1996', encoding: { code: 'edtf' } },  # path [:date,0,:parallelValue,0]
          #       { value: '一九九六' }                              # path [:date,0,:parallelValue,1]
          #     ],
          #     encoding: { code: 'iso8601' }                      # path [:date,0]
          #   }]
          #
          # The value '1996' at [:date,0,:parallelValue,0] matches both [:date,0]
          # (iso8601) and [:date,0,:parallelValue,0] (edtf); the longer prefix wins
          # and it is validated as edtf.  The value '一九九六' at
          # [:date,0,:parallelValue,1] only matches [:date,0] (iso8601).
          encoding_path, code = find_encoding_for(path)
          return unless code

          invalid_groups[encoding_path] ||= []
          invalid_groups[encoding_path] << value unless valid_value?(value, code)
        end

        def validate!
          return if invalid_groups.empty?

          invalid_dates = invalid_groups.filter_map do |path, values|
            next if values.empty?

            [*values, encoding_paths[path]]
          end

          return if invalid_dates.empty?

          raise ValidationError, "Invalid date(s) in description: #{invalid_dates}"
        end

        private

        def encoding_paths
          @encoding_paths ||= {}
        end

        def invalid_groups
          @invalid_groups ||= {}
        end

        def in_date_path?(path)
          path.any? { |part| part.to_s == 'date' }
        end

        def find_encoding_for(path)
          encoding_paths
            .select { |prefix, _| path.first(prefix.length) == prefix }
            .max_by { |prefix, _| prefix.length }
        end

        def valid_value?(value, code)
          send(:"valid_#{code}?", value)
        end

        def valid_edtf?(value)
          return false if value == 'XXXX'

          Date.edtf!(value)
          true
        rescue StandardError
          # NOTE: the upstream EDTF implementation in the `edtf` gem does not
          #       allow a valid pattern that we use (possibly because only level
          #       0 of the spec was implemented?):
          #
          # * Y-20555
          #
          # So we catch the false positives from the upstream gem and allow
          # this pattern to validate
          /\AY-?\d{5,}\Z/.match?(value)
        end

        def valid_iso8601?(value)
          DateTime.iso8601(value)
          true
        rescue StandardError
          false
        end

        def valid_w3cdtf?(value)
          W3cdtfValidator.validate(value)
        end
      end
    end
  end
end
