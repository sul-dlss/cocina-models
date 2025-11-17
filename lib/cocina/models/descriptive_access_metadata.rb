# frozen_string_literal: true

module Cocina
  module Models
    # Information about how to access digital and physical versions of the object.
    class DescriptiveAccessMetadata < BaseModel
      attr_accessor :url, :physicalLocation, :digitalLocation, :accessContact, :digitalRepository, :note
    end
  end
end
