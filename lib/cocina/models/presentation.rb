# frozen_string_literal: true

module Cocina
  module Models
    # Presentation data for the File.
    class Presentation < Struct
      # Descriptive text about an image. This can be used as alt text or for indexing. This should be 130 characters or fewer as this is best practice for alt text.
      attribute? :description, Types::Strict::String
      # Height in pixels
      attribute? :height, Types::Strict::Integer
      # Width in pixels
      attribute? :width, Types::Strict::Integer
    end
  end
end
