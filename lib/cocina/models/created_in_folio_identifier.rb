# frozen_string_literal: true

module Cocina
  module Models
    # A record identifier created in Folio
    # example: in11403803
    CreatedInFolioIdentifier = Types::String.constrained(format: /^in\d+$/)
  end
end
