# frozen_string_literal: true

module Cocina
  module Models
    DoiExceptions = Types::String.constrained(format: %r{^10\.(25740/([vV][aA]90-[cC][tT]15|[sS][yY][xX][aA]-[mM]256|12[qQ][fF]-5243|65[jJ]8-6114)|25936/629[tT]-[bB][xX]79)$})
  end
end
