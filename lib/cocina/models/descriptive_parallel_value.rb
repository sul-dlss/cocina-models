# frozen_string_literal: true

module Cocina
  module Models
    # Value model for multiple representations of the same information (e.g. in different
    # languages).
    class DescriptiveParallelValue < BaseModel
      attr_accessor :parallelValue
    end
  end
end
