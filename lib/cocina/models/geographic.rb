# frozen_string_literal: true

module Cocina
  module Models
    class Geographic < Struct
      # Geographic ISO 19139 XML metadata
      attribute :iso19139, Types::Strict::String
    end
  end
end
