# frozen_string_literal: true

module Cocina
  module Models
    # The output of the message digest algorithm.
    class MessageDigest < BaseModel
      attr_accessor :type, :digest

      TYPES = %w[
        md5
        sha1
      ].freeze
    end
  end
end
