# frozen_string_literal: true

module Cocina
  module Models
    class Administrative < Struct
      # example: druid:bc123df4567
      attribute :hasAdminPolicy, Druid
      attribute :releaseTags, Types::Strict::Array.of(ReleaseTag).default([].freeze)
    end
  end
end
