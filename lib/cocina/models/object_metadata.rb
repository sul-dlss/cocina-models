# frozen_string_literal: true

module Cocina
  module Models
    # Metadata for a cocina object.
    class ObjectMetadata < BaseModel
      attr_accessor :created, :modified, :lock
    end
  end
end
