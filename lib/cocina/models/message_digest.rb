# frozen_string_literal: true

module Cocina
  module Models
    class MessageDigest < Struct
      include Checkable

      TYPES = %w[md5
                 sha1].freeze

      # The algorithm that was used
      attribute :type, Types::Strict::String.enum(*MessageDigest::TYPES)
      # The digest value Base64 encoded
      attribute :digest, Types::Strict::String
    end
  end
end
