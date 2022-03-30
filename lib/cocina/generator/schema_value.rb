# frozen_string_literal: true

module Cocina
  module Generator
    # Class for generating from an openapi value
    class SchemaValue < SchemaBase
      # rubocop:disable Layout/LineLength
      def generate
        # TODO: Remove this when cocina-models 1.0.0 is released.
        @camelcase_properties << name.to_sym unless name == name.underscore

        # optional has to come before default or the default value that gets set will be nil.
        "#{description}#{example}#{relaxed_comment}attribute :#{name.underscore}, Types::#{dry_datatype(schema_doc)}#{optional}#{default}#{enum}#{omittable}"
      end
      # rubocop:enable Layout/LineLength

      private

      def enum
        return '' if !schema_doc.enum || relaxed

        items = use_types? ? "*#{parent.name}::TYPES" : schema_doc.enum.map { |item| quote(item) }.join(', ')

        ".enum(#{items})"
      end

      def use_types?
        parent.is_a?(Schema) && key == 'type'
      end

      def default
        # Provide version as default for cocinaVersion
        return '.default(Cocina::Models::VERSION)' if name == 'cocinaVersion'

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
