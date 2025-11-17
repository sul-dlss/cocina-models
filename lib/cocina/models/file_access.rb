# frozen_string_literal: true

module Cocina
  module Models
    # Access metadata for files
    class FileAccess < BaseModel
      attr_accessor :view, :download, :location, :controlledDigitalLending
    end
  end
end
