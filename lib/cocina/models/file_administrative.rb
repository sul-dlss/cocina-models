# frozen_string_literal: true

module Cocina
  module Models
    class FileAdministrative < Struct
      attribute :publish, Types::Strict::Bool.default(false)
      attribute :sdrPreserve, Types::Strict::Bool.default(true)
      attribute :shelve, Types::Strict::Bool.default(false)
    end
  end
end
