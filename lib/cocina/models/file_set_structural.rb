# frozen_string_literal: true

module Cocina
  module Models
    class FileSetStructural < Struct
      attribute :contains, Types::Strict::Array.of(File).default([])
    end
  end
end
