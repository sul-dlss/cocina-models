# frozen_string_literal: true

module Cocina
  module Models
    # This vocabulary defines some of the supported licenses
    class License < Vocabulary('https://cocina.sul.stanford.edu/licenses/')
      property :none
    end
  end
end
