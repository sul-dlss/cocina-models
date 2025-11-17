# frozen_string_literal: true

module Cocina
  module Models
    # Property model for indicating the parts, aspects, or versions of the resource to
    # which a descriptive element is applicable.
    class AppliesTo < BaseModel
      attr_accessor :appliesTo
    end
  end
end
