# frozen_string_literal: true

module Cocina
  module Models
    class Administrative < Struct
      # example: druid:bc123df4567
      attribute :has_admin_policy, Types::Strict::String
      attribute :release_tags, Types::Strict::Array.of(ReleaseTag).default([].freeze)
    end
  end
end
