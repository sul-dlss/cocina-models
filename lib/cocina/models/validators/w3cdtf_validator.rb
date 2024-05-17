# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates w3cdtf date
      class W3cdtfValidator
        REGEX = /\A(?<year>\d{4})(?:-(?<month>\d\d)(?:-(?<day>\d\d)(?<time>T\d\d:\d\d(?::\d\d(?:.\d+)?)?(?:Z|[+-]\d\d:\d\d))?)?)?\z/ix

        def self.validate(date)
          new(date).validate
        end

        def initialize(date)
          @date = date
        end

        # The W3CDTF format is defined here: http://www.w3.org/TR/NOTE-datetime
        #
        # Year:
        #    YYYY (eg 1997)
        # Year and month:
        #    YYYY-MM (eg 1997-07)
        # Complete date:
        #    YYYY-MM-DD (eg 1997-07-16)
        # Complete date plus hours and minutes:
        #    YYYY-MM-DDThh:mmTZD (eg 1997-07-16T19:20+01:00)
        # Complete date plus hours, minutes and seconds:
        #    YYYY-MM-DDThh:mm:ssTZD (eg 1997-07-16T19:20:30+01:00)
        # Complete date plus hours, minutes, seconds and a decimal fraction of a second
        #    YYYY-MM-DDThh:mm:ss.sTZD (eg 1997-07-16T19:20:30.45+01:00)
        def validate
          return false unless (matches = @date.match(REGEX))
          return true unless matches[:month]
          return (1..12).include? matches[:month].to_i unless matches[:day]

          Date.parse(@date)

          true
        rescue Date::Error
          false
        end
      end
    end
  end
end
