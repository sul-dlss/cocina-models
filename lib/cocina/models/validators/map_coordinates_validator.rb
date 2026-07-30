# frozen_string_literal: true

module Cocina
  module Models
    module Validators
      # Validates map coordinate values.
      class MapCoordinatesValidator
        # A single coordinate, as used in geographic.subject.structuredValue.value
        # when geographic.subject.type is "bounding box coordinates" or "point coordinates"
        # (mapped from MARC 034 $d/$e/$f/$g, or entered directly as decimal
        # lat/long by descriptive spreadsheets). Accepted shapes:
        #   hdddmmss      — hemisphere + zero-padded degrees/minutes/seconds digits (W1800000)
        #   hddd.dddddd   — hemisphere + decimal degrees (E079.533265)
        #   [+-]ddd.dddddd / ddd.dddddd — signed/unsigned decimal degrees, zero-padded or not (34.68444444)
        #   hdddmm.mmmm   — hemisphere + decimal minutes (E07932.5332)
        #   hdddmmss.sss  — hemisphere + decimal seconds (E0793235.575)
        COORDINATE = /\A[NSEW]?[+-]?(?:\d{3}(?:\d{2}){0,2}|\d{1,7}\.\d+)\z/i

        # A single degrees[/minutes[/seconds]] term, as used within a
        # map coordinates range/point value. Hemisphere is optional since the
        # second term of a "--" pair often omits it (e.g. "78°34ʹ").
        TERM = /[NSEW]?\s?\d+(\.\d+)?°?(\d+(\.\d+)?ʹ?)?(\d+(\.\d+)?ʺ?)?/i

        # A longitude or latitude term, or a range of two joined by "--".
        PAIR = /#{TERM}(--#{TERM})?/

        # The full subject.value when subject.type is "map coordinates"
        # (mapped from MARC 255 $c): a longitude pair followed by a latitude
        # pair, separated by "/". Optionally wrapped in parentheses and/or followed by a period.
        RANGE = %r{\A\(?#{PAIR}/#{PAIR}\)?\.?\z}i

        def self.valid_coordinate?(value)
          COORDINATE.match?(value)
        end

        def self.valid_range?(value)
          RANGE.match?(value)
        end
      end
    end
  end
end
