# frozen_string_literal: true

module Cocina
  module Models
    module Utils
      # @param [Cocina::Models::Dro] dro
      # @param [Array<Cocina::Models::File>]
      def self.files(dro)
        dro.structural.contains.flat_map do |fileset|
          fileset.structural.contains
        end
      end
    end
  end
end
