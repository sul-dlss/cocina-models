# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating a vocab
    class Vocab
      CLASS_COMMENT = {
        'ObjectType' => 'This vocabulary defines the top level object type',
        'FileSetType' => 'This vocabulary defines the types of file sets'
      }.freeze

      def self.generate(schemas, output_dir:)
        new(schemas, output_dir: output_dir).generate
      end

      def initialize(schemas, output_dir:)
        @schemas = schemas
        @output_dir = output_dir
      end

      def generate
        names.each do |namespace, v|
          filepath = File.join(output_dir, "#{namespace.underscore}.rb")
          File.write(filepath, contents(namespace, v))
        end
      end

      def contents(namespace, methods)
        <<~RUBY
          # frozen_string_literal: true

          module Cocina
            module Models
              # #{CLASS_COMMENT.fetch(namespace)}
              class #{namespace} < Vocabulary('#{URIS.fetch(namespace)}')
          #{draw_ruby_methods(methods, 6)}
              end
            end
          end
        RUBY
      end

      private

      attr_reader :schemas, :output_dir

      BASE = 'https://cocina.sul.stanford.edu/models/'
      URIS = {
        'ObjectType' => BASE,
        'FileSetType' => "#{BASE}resources/"
      }.freeze
      private_constant :BASE, :URIS

      def vocabs
        type_properties = schemas.values.map { |schema| schema.properties&.[]('type') }.compact
        type_properties.map(&:enum).flat_map(&:to_a)
                       .filter { |vocab| vocab.start_with?(BASE) }
                       .uniq
                       .sort
      end

      def names
        @names ||= vocabs.each_with_object({}) do |vocab, object|
          namespaced = vocab.delete_prefix(BASE)
          namespace, name = namespaced.include?('/') ? namespaced.split('/') : ['ObjectType', namespaced]
          namespace = 'FileSetType' if namespace == 'resources'
          object[namespace] ||= []
          object[namespace] << name
        end
      end

      def draw_ruby_methods(methods, indent)
        spaces = ' ' * indent
        methods.map do |name|
          if name == '3d'
            "#{spaces}property :'3d', method_name: :three_dimensional"
          else
            name = "'#{name}'" if name.match?(/(^\d)|-/)
            "#{spaces}property :#{name}"
          end
        end.join("\n")
      end
    end
  end
end
