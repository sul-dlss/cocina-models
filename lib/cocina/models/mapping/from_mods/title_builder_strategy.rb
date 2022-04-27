# frozen_string_literal: true

module Cocina
  module Models
    module Mapping
      module FromMods
        # Decides how to build a title based on whether this is a registered Hydrus object or not.
        class TitleBuilderStrategy
          # @param [String] label
          # @return [#build] a class that can build a title
          def self.find(label:)
            # Some hydrus items don't have titles, so using label. See https://github.com/sul-dlss/hydrus/issues/421
            label == 'Hydrus' ? HydrusDefaultTitleBuilder : Title
          end
        end
      end
    end
  end
end
