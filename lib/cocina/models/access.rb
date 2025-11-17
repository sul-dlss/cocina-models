# frozen_string_literal: true

module Cocina
  module Models
    class Access < BaseModel
      attr_accessor :view, :download, :location, :controlledDigitalLending
    end
  end
end
