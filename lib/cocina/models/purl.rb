# frozen_string_literal: true

module Cocina
  module Models
    # Stanford persistent URL associated with the related resource.
    Purl = Types::String.constrained(format: %r{^https://})
  end
end
