# frozen_string_literal: true

require 'edtf'
require 'jsonpath'
require 'rss'

module Cocina
  module Models
    module Validators
      # Validates that dates of known types are type-valid
      class DateTimeValidator
        VALIDATABLE_TYPES = %w[edtf iso8601 w3cdtf].freeze

        def self.validate(_clazz, attributes)
          new(attributes).validate
        end

        def initialize(attributes)
          @attributes = attributes
        end

        def validate
          return unless meets_preconditions?

          return if invalid_dates.empty?

          raise ValidationError, "Invalid date(s) for #{druid}: #{invalid_dates}"
        end

        private

        attr_reader :attributes

        def meets_preconditions?
          attributes.key?(:description)
        end

        def invalid_dates
          @invalid_dates ||= validatable_dates.filter_map do |date_hash|
            code = date_hash.dig('encoding', 'code')
            bad_values = JsonPath.new('$..value').on(date_hash.to_json).reject do |value|
              send("valid_#{code}?", value)
            end

            next if bad_values.empty?

            [*bad_values, code]
          end
        end

        def validatable_dates
          # Why is the `uniq` needed below? Odd behavior when handling highly nested use cases:
          #
          # > JsonPath.new("$..date..[?(@.encoding.code =~ /#{VALIDATABLE_TYPES.join('|')}/)]").on(attributes[:description].to_json)
          # > [
          #     {"structuredValue"=>[{"value"=>"1996", "type"=>"start"}, {"value"=>"1998", "type"=>"end"}], "encoding"=>{"code"=>"iso8601"}},
          #     {"structuredValue"=>[{"value"=>"1996", "type"=>"start"}, {"value"=>"1998", "type"=>"end"}], "encoding"=>{"code"=>"iso8601"}}
          # ]
          #
          # Notice how the JSONPath expression returns the *same exact* structure twice despite only being present once in the data.
          JsonPath
            .new("$..date..[?(@.encoding.code =~ /#{VALIDATABLE_TYPES.join('|')}/)]")
            .on(attributes[:description].to_json)
            .uniq
        end

        def valid_edtf?(value)
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
          /\AY-?\d{5,}\Z/.match?(value) ||
            /\A-?\d{1,3}\Z/.match?(value) # temporarily allow format violations
        end

        def valid_iso8601?(value)
          DateTime.iso8601(value)
          true
        rescue StandardError
          false
        end

        def valid_w3cdtf?(value)
          Time.w3cdtf(value)
          true
        rescue StandardError
          # NOTE: the upstream W3CDTF implementation in the `rss` gem does not
          #       allow two patterns that should be valid per the specification:
          #
          # * YYYY
          # * YYYY-MM
          #
          # This catches the false positives from the upstream gem and allow
          # these two patterns to validate
          /\A\d{4}(-0[1-9]|-1[0-2])?\Z/.match?(value)
        end

        def druid
          @druid ||= attributes[:externalIdentifier]
        end
      end
    end
  end
end
