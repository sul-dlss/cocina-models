# frozen_string_literal: true

module Cocina
  module Models
    class Vocabulary
      # @private
      # Disabled this cop because we want @@uri to be inheritable.
      # rubocop:disable Style/ClassVars
      def self.create(uri)
        @@uri = uri
        self
      end
      # rubocop:enable Style/ClassVars

      def self.to_s
        @@uri
      end

      def self.property(name, method_name: name.to_s.underscore.to_sym)
        uri = [to_s, name].join
        properties[name] = uri
        (class << self; self; end).send(:define_method, method_name) { uri }
      end

      def self.properties
        @properties ||= {}
      end
    end
  end
end
