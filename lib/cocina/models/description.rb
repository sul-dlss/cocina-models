# frozen_string_literal: true

module Cocina
  module Models
    # Descriptive metadata.  See http://sul-dlss.github.io/cocina-models/maps/Description.json
    class Description < Struct
      # Title element.  See http://sul-dlss.github.io/cocina-models/maps/Title.json
      class Title < Struct
        attribute :primary, Types::Params::Bool # will coerce 'true' to true
        attribute :titleFull, Types::Strict::String
      end

      attribute :title, Types::Strict::Array.of(Title)
    end
  end
end
