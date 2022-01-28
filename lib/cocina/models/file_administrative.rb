# frozen_string_literal: true

module Cocina
  module Models
    class FileAdministrative < Struct
      attribute :publish, Types::Strict::Bool.default(false)
      attribute :sdr_preserve, Types::Strict::Bool.default(true)
      attribute :shelve, Types::Strict::Bool.default(false)

      alias sdrPreserve sdr_preserve
      deprecation_deprecate :sdrPreserve
    end
  end
end
