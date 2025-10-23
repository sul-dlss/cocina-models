# frozen_string_literal: true

module Cocina
  module Models
    # A record identifier created in Folio
    CreatedInFolioIdentifier = Types::String.constrained(format: /^in\d+$/)
  end
end
