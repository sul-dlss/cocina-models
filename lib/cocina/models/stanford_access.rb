# frozen_string_literal: true

module Cocina
  module Models
    class StanfordAccess < Struct
      # Access level.
      attribute :view, Types::Strict::String.enum('stanford')
      # Download access level.
      attribute :download, Types::Strict::String.enum('stanford')
      # Not used for this access type, must be null.
      attribute? :location, Types::Strict::String.optional.enum('')
      attribute? :controlledDigitalLending, Types::Strict::Bool.default(false).enum(false)
    end
  end
end
