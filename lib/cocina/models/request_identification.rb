# frozen_string_literal: true

module Cocina
  module Models
    # Same as a Identification, but requires a sourceId and doesn't permit a DOI.
    class RequestIdentification < BaseModel
      attr_accessor :barcode, :catalogLinks, :sourceId
    end
  end
end
