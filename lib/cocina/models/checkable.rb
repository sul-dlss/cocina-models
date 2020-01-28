# frozen_string_literal: true

module Cocina
  module Models
    # A common interface for interrogating a model instance's type
    module Checkable
      def admin_policy?
        (self.class::TYPES & AdminPolicy::TYPES).any?
      end

      def collection?
        (self.class::TYPES & Collection::TYPES).any?
      end

      def dro?
        (self.class::TYPES & DRO::TYPES).any?
      end

      def file?
        (self.class::TYPES & File::TYPES).any?
      end

      def file_set?
        (self.class::TYPES & FileSet::TYPES).any?
      end
    end
  end
end
