# frozen_string_literal: true

module Cocina
  module Models
    class Title < Struct
      # Is this the primary title for the object
      attribute :primary, Types::Strict::Bool.default(false)
      # The full title for the object
      attribute :titleFull, Types::Strict::String
    end
  end
end
