# frozen_string_literal: true

module Cocina
  module Models
    class ControlledDigitalLendingAccess < Struct
      # Access level.
      attribute :view, Types::Strict::String.enum('stanford')
      # Download access level.
      attribute :download, Types::Strict::String.enum('none')
      # Not used for this access type, must be null.
      attribute :location, Types::Strict::String.optional.enum('').meta(omittable: true)
      # Available for controlled digital lending.
      attribute :controlledDigitalLending, Types::Strict::Bool.default(false)
    end
  end
end
