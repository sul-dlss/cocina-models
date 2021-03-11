# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating a vocab
    class Vocab
      def initialize(schemas)
        @schemas = schemas
      end

      def filename
        'vocab.rb'
      end

      def generate
        <<~RUBY
                    # frozen_string_literal: true

                    module Cocina
                      module Models
                        # A digital repository object.  See http://sul-dlss.github.io/cocina-models/maps/DRO.json
                        class Vocab

          #{vocab_methods}

                        end
                      end
          end
        RUBY
      end

      private

      attr_reader :schemas

      BASE = 'http://cocina.sul.stanford.edu/models/'

      def vocabs
        type_properties = schemas.values.map { |schema| schema.properties['type'] }.compact
        type_properties.map(&:enum).flat_map(&:to_a)
                       .filter { |vocab| vocab.start_with?(BASE) }
                       .uniq
                       .sort
      end

      def vocab_methods
        names = vocabs.each_with_object({}) do |vocab, object|
          # Note special handling of 3d
          namespaced = vocab.delete_prefix(BASE).delete_suffix('.jsonld')
                            .gsub('-', '_').gsub('3d', 'three_dimensional')
          namespace, name = namespaced.include?('/') ? namespaced.split('/') : [:root, namespaced]
          object[namespace] ||= {}
          object[namespace][name] = vocab
        end
        draw_namespaced_methods(names)
      end

      def draw_namespaced_methods(names)
        names.flat_map do |namespace, methods|
          [].tap do |items|
            items << "class #{namespace.capitalize}" unless namespace == :root
            items << draw_ruby_methods(methods)
            items << 'end' unless namespace == :root
          end
        end.join("\n")
      end

      def draw_ruby_methods(methods)
        methods.map do |name, vocab|
          <<~RUBY
            def self.#{name}
              "#{vocab}"
            end

          RUBY
        end.join("\n")
      end
    end
  end
end
