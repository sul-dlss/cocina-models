# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMarc
        # Creates Cocina Description objects from MARC record
        class Description
          # @param [Hash] marc MARC record from FOLIO
          # @param [String] druid
          # @oaram [String] label
          # @param [TitleBuilder] title_builder - defaults to Title class
          # @param [Cocina::Models::Mapping::ErrorNotifier] notifier
          # @return [Hash] a hash that can be mapped to a Cocina Description model
          def self.props(marc:, druid:, label:, title_builder: Title, notifier: nil)
            new(title_builder: title_builder, marc: marc, druid: druid, label: label, notifier: notifier).props
          end

          def initialize(title_builder:, marc:, label:, druid:, notifier:)
            @title_builder = title_builder
            @marc = marc
            @notifier = notifier || ErrorNotifier.new(druid: druid)
            @druid = druid
            @label = label
          end

          # @return [Hash] a hash that can be mapped to a Cocina Description model
          def props
            return nil if marc.nil?

            props = DescriptionBuilder.build(title_builder: title_builder,
                                             marc: marc,
                                             notifier: notifier,
                                             purl: druid ? Cocina::Models::Mapping::Purl.for(druid: druid) : nil)
            props[:title] = [{ value: label }] unless props.key?(:title)
            props
          end

          private

          attr_reader :title_builder, :marc, :notifier, :druid, :label
        end
      end
    end
  end
end
