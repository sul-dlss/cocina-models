# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMarc
        # Maps titles
        class Title
          # @param [Hash] marc MARC record from FOLIO
          # @param [boolean] require_title notify if true and title is missing.
          # @param [Cocina::Models::Mapping::ErrorNotifier] notifier
          # @return [Hash] a hash that can be mapped to a cocina model
          def self.build(marc:, notifier:, require_title: true)
            new(marc: marc, notifier: notifier).build(require_title: require_title)
          end

          def initialize(marc:, notifier:)
            @marc = marc
            @notifier = notifier
          end

          def build(require_title: true)
            result = TitleBuilder.build(marc: marc, notifier: notifier)
            notifier.error('Missing title') if result.nil? && require_title

            result
          end

          private

          attr_reader :marc, :notifier
        end
      end
    end
  end
end
