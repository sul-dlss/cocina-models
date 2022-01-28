# frozen_string_literal: true

module Cocina
  module Models
    class FileAccess < Struct
      # Access level.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute? :view, Types::Strict::String.optional.default('dark')
      # Download access level.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute? :download, Types::Strict::String.optional.default('none')
      # Not used for this access type, must be null.
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute? :location, Types::Strict::String.optional
      # Validation of this property is relaxed. See the openapi for full validation.
      attribute? :controlled_digital_lending, Types::Strict::Bool.optional

      alias controlledDigitalLending controlled_digital_lending
      deprecation_deprecate :controlledDigitalLending
    end
  end
end
