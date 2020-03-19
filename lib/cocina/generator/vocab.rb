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

      # rubocop:disable Style/MultilineBlockChain
      def vocabs
        schemas.values.map do |schema|
          type_property = schema.properties['type']
          type_property.nil? ? [] : type_property.enum.to_a
        end
               .flatten
               .uniq
               .sort
               .filter { |vocab| vocab.start_with?('http://cocina.sul.stanford.edu/models') }
      end
      # rubocop:enable Style/MultilineBlockChain

      def vocab_methods
        # Note special handling of 3d
        vocabs.map do |vocab|
          name = vocab[38, vocab.size - 45].gsub('-', '_').gsub('3d', 'three_dimensional')
          <<-RUBY
    def self.#{name}
      '#{vocab}'
    end
          RUBY
        end.join("\n")
      end
    end
  end
end
