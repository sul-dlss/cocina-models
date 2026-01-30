# frozen_string_literal: true

require 'marc'

module Cocina
  module Models
    module Mapping
      module FromMarc
        # Creates Cocina Description objects from MARC record
        class Description
          # @see #initialize
          # @see #props
          def self.props(...)
            new(...).props
          end

          # @param [MARC::Record] marc MARC record from FOLIO
          # @param [String] druid
          # @param [Cocina::Models::Mapping::ErrorNotifier] notifier
          def initialize(marc:, druid:, notifier: nil)
            @marc = marc
            @notifier = notifier || ErrorNotifier.new(druid:)
            @purl = Cocina::Models::Mapping::Purl.for(druid:) if druid
          end

          # @return [Hash] a hash that can be mapped to a Cocina Description model
          def props
            DescriptionBuilder.build(marc:, notifier:, purl:) if marc
          end

          private

          attr_reader :marc, :notifier, :purl
        end
      end
    end
  end
end
