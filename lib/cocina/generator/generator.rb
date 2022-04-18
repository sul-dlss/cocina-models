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
        generate_descriptive_docs
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
        Vocab.generate(schemas, output_dir: options[:output])
      end

      desc 'generate_descriptive_docs', 'generate descriptive documentation'
      def generate_descriptive_docs
        markdown = YAML.load_file('description_types.yml').map do |field, types|
          header_markdown = field_markdown_from(field)
          types_markdown = types_markdown_from(types)

          <<~MARKDOWN
            #{'#' * (field.count('.') + 1)} #{header_markdown}
            _Path: #{field}_
            #{types_markdown}
          MARKDOWN
        end.join("\n")

        remove_file 'docs/description_types.md'
        create_file 'docs/description_types.md', h1_markdown + markdown
      end

      private

      def h1_markdown
        <<~MARKDOWN
          # Description types

        MARKDOWN
      end

      def field_markdown_from(field)
        header = field.split('.')
                      .grep_v(/groupedValue|structuredValue/)
                      .join(' ')
                      .capitalize

        header_suffix = if field.ends_with?('structuredValue')
                          'part types for structured value'
                        elsif field.ends_with?('groupedValue')
                          'types for grouped value (MODS legacy)'
                        else
                          'types'
                        end
        "#{header} #{header_suffix}"
      end

      def types_markdown_from(types)
        types.map do |type|
          "  * #{type['value']}".tap do |type_value|
            type_value << ": #{type['description']}" if type['description']
          end
        end.join("\n")
      end

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

      NO_CLEAN = [
        'checkable.rb',
        'license.rb',
        'validatable.rb',
        'version.rb',
        'vocabulary.rb'
      ].freeze

      def clean_output
        FileUtils.mkdir_p(options[:output])
        files = Dir.glob("#{options[:output]}/*.rb")
        # Leave alone
        NO_CLEAN.each { |filename| files.delete("#{options[:output]}/#{filename}") }

        FileUtils.rm_f(files)
      end
    end
  end
end
