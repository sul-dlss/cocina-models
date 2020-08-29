# frozen_string_literal: true

module Cocina
  module Models
    SourceId = Types::String.constrained(
      format: /^.+:.+$/i
    )
  end
end
