# frozen_string_literal: true

require 'fileutils'

module Cocina
  module Generator
    # Class for generating Cocina models from openapi.
    class Generator < Thor
      include Thor::Actions

      class_option :openapi, desc: 'Path of openapi.yml', default: 'openapi.yml'
      class_option :output, desc: 'Path for output', default: 'lib/cocina/models'

      def self.source_root
        File.dirname(__FILE__)
      end

      desc 'generate', 'generate for all schemas'
      def generate
        clean_output

        # rubocop:disable Style/HashEachMethods
        # This is not a Hash
        schemas.keys.each do |schema_name|
          schema = schema_for(schema_name)
          generate_for(schema) if schema
        end
        # rubocop:enable Style/HashEachMethods

        generate_vocab
      end

      desc 'generate_schema SCHEMA_NAME', 'generate for SCHEMA_NAME'
      def generate_schema(schema_name)
        schema = schema_for(schema_name)
        raise 'Cannot generate' if schema.nil?

        FileUtils.mkdir_p(options[:output])

        generate_for(schema)
      end

      desc 'generate_vocab', 'generate vocab'
      def generate_vocab
        vocab = Vocab.new(schemas)
        filepath = "#{options[:output]}/#{vocab.filename}"
        FileUtils.rm_f(filepath)

        create_file filepath, vocab.generate
        run("rubocop -a #{filepath} > /dev/null")
      end

      private

      def schemas
        @schemas ||= Openapi3Parser.load_file(options[:openapi]).components.schemas
      end

      def schema_for(schema_name)
        schema_doc = schemas[schema_name]
        return nil if schema_doc.nil?

        case schema_doc.type
        when 'object'
          Schema.new(schema_doc)
        when 'string'
          Datatype.new(schema_doc)
        end
      end

      def generate_for(schema)
        filepath = "#{options[:output]}/#{schema.filename}"
        FileUtils.rm_f(filepath)

        create_file filepath, schema.generate
        run("rubocop -a #{filepath} > /dev/null")
      end

      def clean_output
        FileUtils.mkdir_p(options[:output])
        files = Dir.glob("#{options[:output]}/*.rb")
        # Leave alone
        files.delete("#{options[:output]}/version.rb")
        files.delete("#{options[:output]}/checkable.rb")
        files.delete("#{options[:output]}/validator.rb")
        FileUtils.rm_f(files)
      end
    end
  end
end
