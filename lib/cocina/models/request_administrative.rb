# frozen_string_literal: true

module Cocina
  module Models
    class RequestAdministrative < Struct
      # example: druid:bc123df4567
      attribute :hasAdminPolicy, Druid
      # Internal project this resource is a part of. This governs routing of messages about this object.
      # example: Google Books
      attribute? :partOfProject, Types::Strict::String
    end
  end
end
