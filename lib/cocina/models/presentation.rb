# frozen_string_literal: true

module Cocina
  module Models
    # Presentation data for the File.
    class Presentation < Struct
      # Height in pixels
      attribute? :height, Types::Strict::Integer
      # Width in pixels
      attribute? :width, Types::Strict::Integer
    end
  end
end
