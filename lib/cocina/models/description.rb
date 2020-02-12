# frozen_string_literal: true

module Cocina
  module Models
    # Descriptive metadata.  See http://sul-dlss.github.io/cocina-models/maps/Description.json
    class Description < Dry::Struct
      # Title element.  See http://sul-dlss.github.io/cocina-models/maps/Title.json
      class Title < Dry::Struct
        attribute :primary, Types::Strict::Bool
        attribute :titleFull, Types::Strict::String

        def self.from_dynamic(dyn)
          Title.new(primary: dyn['primary'],
                    titleFull: dyn['titleFull'])
        end
      end

      attribute :title, Types::Strict::Array.of(Title)

      def self.from_dynamic(dyn)
        params = {
          title: dyn.fetch('title').map { |title| Title.from_dynamic(title) }
        }
        Description.new(params)
      end
    end
  end
end
