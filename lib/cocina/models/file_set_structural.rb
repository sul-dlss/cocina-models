# frozen_string_literal: true

module Cocina
  module Models
    # Structural metadata
    class FileSetStructural < Struct
      attribute :contains, Types::Strict::Array.of(File).default([].freeze)
    end
  end
end
