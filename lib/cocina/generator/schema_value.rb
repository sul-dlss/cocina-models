# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating from an openapi value
    class SchemaValue < SchemaBase
      # rubocop:disable Metrics/LineLength
      def generate
        "#{description}#{example}attribute :#{name.camelize(:lower)}, Types::#{dry_datatype}#{default}#{enum}#{omittable}"
      end
      # rubocop:enable Metrics/LineLength

      private

      def dry_datatype
        case schema_doc.type
        when 'integer'
          'Strict::Integer'
        when 'string'
          string_dry_datatype
        when 'boolean'
          'Strict::Bool'
        else
          raise "#{schema_doc.type} not supported"
        end
      end

      def string_dry_datatype
        case schema_doc.format
        when 'date-time'
          'Params::DateTime'
        else
          'Strict::String'
        end
      end

      def enum
        return '' unless schema_doc.enum

        items = use_types? ? "*#{parent.name}::TYPES" : schema_doc.enum.map { |item| quote(item) }.join(', ')

        ".enum(#{items})"
      end

      def use_types?
        parent.is_a?(Schema) && key == 'type'
      end

      def default
        # If type is boolean and default is false, erroneously getting a nil.
        # Assuming that if required, then default is false.
        default = schema_doc.default
        default = false if default.nil? && schema_doc.type == 'boolean' && required
        return '' if default.nil?

        ".default(#{quote(default)})"
      end
    end
  end
end
