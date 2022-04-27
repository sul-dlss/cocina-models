# frozen_string_literal: true

module Cocina
  module Models
    class DescriptiveValueSingle < Struct
      # String or integer value of the descriptive element.
      attribute? :value, Types::Nominal::Any
    end
  end
end
