# frozen_string_literal: true

module Cocina
  module Models
    DoiExceptions = Types::String.constrained(format: %r{^10\.(25740/[a-zA-Z0-9]{4}-[a-zA-Z0-9]{4}|25936/629[tT]-[bB][xX]79)$})
  end
end
