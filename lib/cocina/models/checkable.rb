# frozen_string_literal: true

module Cocina
  module Models
    # A common interface for interrogating a model instance's type
    module Checkable
      def admin_policy?
        self.class::TYPES.intersect?(AdminPolicy::TYPES)
      end

      def collection?
        self.class::TYPES.intersect?(Collection::TYPES)
      end

      def dro?
        self.class::TYPES.intersect?(DRO::TYPES)
      end

      def file?
        self.class::TYPES.intersect?(File::TYPES)
      end

      def file_set?
        self.class::TYPES.intersect?(FileSet::TYPES)
      end
    end
  end
end
