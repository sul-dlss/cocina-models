# frozen_string_literal: true

module Cocina
  module Models
    # Metadata for a cocina object.
    class ObjectMetadata < Struct
      # When the object was created.
      attribute? :created, Types::Params::DateTime
      # When the object was modified.
      attribute? :modified, Types::Params::DateTime
      # Key for optimistic locking. The contents of the key is not specified.
      attribute :lock, Types::Strict::String
    end
  end
end
