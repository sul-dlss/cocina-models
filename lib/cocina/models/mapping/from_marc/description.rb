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
          # @param [String] label
          # @param [String] druid
          # @param [Cocina::Models::Mapping::ErrorNotifier] notifier
          def initialize(marc:, label:, druid:, notifier: nil)
            @marc = marc
            @notifier = notifier || ErrorNotifier.new(druid: druid)
            @druid = druid
            @label = label
          end

          # @return [Hash] a hash that can be mapped to a Cocina Description model
          def props
            return nil if marc.nil?

            DescriptionBuilder.build(marc: marc,
                                     notifier: notifier,
                                     purl: druid ? Cocina::Models::Mapping::Purl.for(druid: druid) : nil).tap do |properties|
              properties[:title] = [{ value: label }] unless properties.key?(:title)
            end
          end

          private

          attr_reader :title_builder, :marc, :notifier, :druid, :label
        end
      end
    end
  end
end
