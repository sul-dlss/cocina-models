# frozen_string_literal: true

require 'geo/coord'

module Cocina
  module Models
    module Validators
      # Validates that geospatial coordinates are parseable in DMS notation
      class MapCoordinatesValidator
        def self.validate(clazz, attributes)
          new(clazz, attributes).validate
        end

        def initialize(clazz, attributes)
          @clazz = clazz
          @attributes = attributes
        end

        # Valid if no coordinates, or all coordinates are parseable
        def validate
          coordinates.map(&method(:parse))
        end

        private

        attr_reader :clazz, :attributes

        def druid
          @druid ||= attributes[:externalIdentifier]
        end

        # Text of all 'subject' elements of type 'map coordinates', if any
        def coordinates
          @coordinates ||= (attributes.dig(:description, :subject) || [])
                           .select { |subject| subject[:type] == 'map coordinates' }
                           .map { |subject| subject[:value] }
        end

        # Coordinates are separated by -- or /
        # Example: W 62°51ʹ00ʺ--W 62°04ʹ00ʺ--N 17°30ʹ20ʺ--N 16°32ʹ00ʺ
        COORD_SEPARATOR = %r{ ?--|/}

        # Attempt to parse coordinates in DMS notation
        def parse(coordinate_text)
          coordinate_parts = coordinate_text.split(COORD_SEPARATOR)
          case coordinate_parts.length
          when 2  # single point
            [parse_coord(coordinate_parts[0], coordinate_parts[1])]
          when 4  # bounding box
            [parse_coord(coordinate_parts[0], coordinate_parts[2]), parse_coord(coordinate_parts[1], coordinate_parts[3])]
          else
            raise ValidationError, "Invalid map coordinates for #{druid}: #{coordinate_text}"
          end
        rescue ArgumentError
          raise ValidationError, "Invalid map coordinates for #{druid}: #{coordinate_text}"
        end

        # Coordinate validation from:
        # https://github.com/iiif-prezi/osullivan/blob/main/lib/iiif/v3/presentation/nav_place.rb
        COORD_REGEX = /(?<hemisphere>[NSEW]) (?<degrees>\d+)[°⁰*] ?(?<minutes>\d+)?[ʹ']? ?(?<seconds>\d+)?[ʺ"]?/

        # Attempt to parse a single coordinate from longitude/latitude strings
        # Raises ArgumentError if the coordinate is invalid
        def parse_coord(long_str, lat_str)
          long = long_str.match(COORD_REGEX)
          lat = lat_str.match(COORD_REGEX)
          raise ArgumentError unless long && lat

          Geo::Coord.new(
            latd: lat[:degrees], latm: lat[:minutes], lats: lat[:seconds], lath: lat[:hemisphere],
            lngd: long[:degrees], lngm: long[:minutes], lngs: long[:seconds], lngh: long[:hemisphere]
          )
        end
      end
    end
  end
end
