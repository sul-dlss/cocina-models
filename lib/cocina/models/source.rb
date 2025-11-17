# frozen_string_literal: true

module Cocina
  module Models
    # Property model for indicating the vocabulary, authority, or other origin for a term,
    # code, or identifier.
    class Source < BaseModel
      attr_accessor :code, :uri, :value, :note, :version
    end
  end
end
