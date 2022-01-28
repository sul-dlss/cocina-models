# frozen_string_literal: true

module Cocina
  module Models
    class WorldAccess < Struct
      # Access level.
      attribute :view, Types::Strict::String.enum('world')
      # Download access level.
      attribute :download, Types::Strict::String.enum('none', 'stanford', 'world')
      # Not used for this access type, must be null.
      attribute :location, Types::Strict::String.optional.enum('').meta(omittable: true)
      attribute :controlled_digital_lending, Types::Strict::Bool.enum(false).meta(omittable: true)
    end
  end
end
