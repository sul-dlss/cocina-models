# frozen_string_literal: true

module Cocina
  module Models
    class Identification < BaseModel
      attr_accessor :barcode, :catalogLinks, :doi, :sourceId
    end
  end
end
