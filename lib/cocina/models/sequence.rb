# frozen_string_literal: true

module Cocina
  module Models
    # A sequence or ordering of resources within a Collection or Object.
    class Sequence < BaseModel
      attr_accessor :members, :viewingDirection
    end
  end
end
