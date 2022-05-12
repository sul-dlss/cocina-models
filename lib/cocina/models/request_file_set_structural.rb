# frozen_string_literal: true

module Cocina
  module Models
    # Structural metadata
    class RequestFileSetStructural < Struct
      attribute :contains, Types::Strict::Array.of(RequestFile).default([].freeze)
    end
  end
end
