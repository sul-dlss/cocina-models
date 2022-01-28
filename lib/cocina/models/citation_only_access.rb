# frozen_string_literal: true

module Cocina
  module Models
    class CitationOnlyAccess < Struct
      # Access level.
      attribute :view, Types::Strict::String.enum('citation-only')
      # Download access level.
      attribute :download, Types::Strict::String.enum('none')
      # Not used for this access type, must be null.
      attribute? :location, Types::Strict::String.optional.enum('')
      attribute? :controlled_digital_lending, Types::Strict::Bool.enum(false)

      alias controlledDigitalLending controlled_digital_lending
      deprecation_deprecate :controlledDigitalLending
    end
  end
end
