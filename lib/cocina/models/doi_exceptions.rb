# frozen_string_literal: true

module Cocina
  module Models
    DoiExceptions = Types::String.constrained(
      format: %r{^10\.(25740/(VA90-CT15|syxa-m256|12qf-5243|65j8-6114)|25936/629T-BX79)$}i
    )
  end
end
