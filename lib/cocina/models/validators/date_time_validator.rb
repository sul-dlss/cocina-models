# frozen_string_literal: true

require 'edtf'
require 'jsonpath'

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

        def druid
          @druid ||= attributes[:externalIdentifier]
        end
      end
    end
  end
end
