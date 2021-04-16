# frozen_string_literal: true

module Cocina
  module Models
    class ControlledDigitalLendingAccess < Struct
      # Access level.
      attribute :access, Types::Strict::String.enum('stanford')
      # Download access level.
      attribute :download, Types::Strict::String.enum('none')
      # If access is "location-based", which location should have access.
      attribute :readLocation, Types::Strict::String.optional.enum('').meta(omittable: true)
      # Available for controlled digital lending.
      attribute :controlledDigitalLending, Types::Strict::Bool.default(false)
    end
  end
end
