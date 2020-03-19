# frozen_string_literal: true

module Cocina
  module Models
    class Geographic < Struct
      attribute :iso19139, Types::Strict::String
    end
  end
end
