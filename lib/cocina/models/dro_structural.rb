# frozen_string_literal: true

module Cocina
  module Models
    # Structural metadata
    class DROStructural < BaseModel
      attr_accessor :contains, :hasMemberOrders, :isMemberOf
    end
  end
end
