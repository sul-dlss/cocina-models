# frozen_string_literal: true

module Cocina
  module Models
    # Access role conferred by an AdminPolicy to objects within it. (used by Argo)
    class AccessRole < BaseModel
      attr_accessor :name, :members
    end
  end
end
