# frozen_string_literal: true

module Cocina
  module Models
    CreatedInFolioIdentifier = Types::String.constrained(
      format: /^in\d+$/
    )
  end
end
