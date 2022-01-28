# frozen_string_literal: true

module Cocina
  module Models
    class ControlledDigitalLendingAccess < Struct
      # Access level.
      attribute :view, Types::Strict::String.enum('stanford')
      # Download access level.
      attribute :download, Types::Strict::String.enum('none')
      # Not used for this access type, must be null.
      attribute? :location, Types::Strict::String.optional.enum('')
      # Available for controlled digital lending.
      attribute :controlled_digital_lending, Types::Strict::Bool.default(false)

      alias controlledDigitalLending controlled_digital_lending
      deprecation_deprecate :controlledDigitalLending
    end
  end
end
