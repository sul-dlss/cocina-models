# frozen_string_literal: true

module Cocina
  module Models
    # Structural metadata
    class DROStructural < Struct
      # Filesets that contain the digital representations (Files)
      attribute :contains, Types::Strict::Array.of(FileSet).default([].freeze)
      # Provided sequences or orderings of members, including some metadata about each sequence
      # (i.e. sequence label, sequence type, if the sequence is primary, etc.).
      attribute :hasMemberOrders, Types::Strict::Array.of(Sequence).default([].freeze)
      # Collections that this DRO is a member of
      attribute :isMemberOf, Types::Strict::Array.of(Druid).default([].freeze)
    end
  end
end
