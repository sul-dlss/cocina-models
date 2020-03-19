# frozen_string_literal: true

module Cocina
  module Models
    class Title < Struct
      attribute :primary, Types::Strict::Bool.default(false)
      attribute :titleFull, Types::Strict::String
    end
  end
end
