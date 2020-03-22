# frozen_string_literal: true

module Cocina
  module Models
    class Access < Struct
      # Access level
      attribute :access, Types::Strict::String.default('dark').enum('world', 'stanford', 'location-based', 'citation-only', 'dark').meta(omittable: true)
    end
  end
end
