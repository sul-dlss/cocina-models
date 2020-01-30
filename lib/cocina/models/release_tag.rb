# frozen_string_literal: true

module Cocina
  module Models
    # Subschema for release tags
    class ReleaseTag < Dry::Struct
      attribute :to, Types::Strict::String.enum('Searchworks', 'Earthworks')
      attribute :what, Types::Strict::String.enum('self', 'collection')
      # we use 'when' other places, but that's reserved word, so 'date' it is!
      attribute :date, Types::Params::DateTime
      attribute :who, Types::Strict::String
      attribute :release, Types::Params::Bool

      def self.from_dynamic(dyn)
        ReleaseTag.new(to: dyn['to'],
                       what: dyn['what'],
                       date: dyn['date'],
                       who: dyn['who'],
                       release: dyn['release'])
      end
    end
  end
end
