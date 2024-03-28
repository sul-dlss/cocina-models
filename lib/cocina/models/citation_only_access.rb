# frozen_string_literal: true

module Cocina
  module Models
    # A type of access for an object wherein users can see the metadata and a list of files, but the files will not have view or download access
    class CitationOnlyAccess < Struct
      # Access level.
      attribute :view, Types::Strict::String.enum('citation-only')
      # Download access level.
      attribute :download, Types::Strict::String.enum('none')
      # Not used for this access type, must be null.
      attribute? :location, Types::Strict::String.optional.enum('')
      attribute? :controlledDigitalLending, Types::Strict::Bool.default(false).enum(false)
    end
  end
end
