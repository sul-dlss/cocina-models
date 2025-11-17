# frozen_string_literal: true

module Cocina
  module Models
    # A type of access for an object wherein users can see the metadata and a list of files,
    # but the files will not have view or download access
    class CitationOnlyAccess < BaseModel
      attr_accessor :view, :download, :location, :controlledDigitalLending
    end
  end
end
