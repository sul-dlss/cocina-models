# frozen_string_literal: true

module Cocina
  module Models
    class Embargo < BaseModel
      attr_accessor :releaseDate, :useAndReproductionStatement
    end
  end
end
