# frozen_string_literal: true

module Cocina
  module Models
    class Description < Struct
      attribute :title, Types::Strict::Array.of(Title).default([].freeze)
    end
  end
end
