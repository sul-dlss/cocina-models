# frozen_string_literal: true

module Cocina
  module Models
    class DarkAccess < Struct
      # Access level.
      attribute :view, Types::Strict::String.default('dark').enum('dark').meta(omittable: true)
      # Download access level.
      attribute :download, Types::Strict::String.default('none').enum('none').meta(omittable: true)
      # Not used for this access type, must be null.
      attribute :location, Types::Strict::String.optional.enum('').meta(omittable: true)
      attribute :controlled_digital_lending, Types::Strict::Bool.enum(false).meta(omittable: true)
    end
  end
end
