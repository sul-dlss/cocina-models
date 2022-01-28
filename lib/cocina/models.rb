# frozen_string_literal: true

require 'cocina/models/version'
require 'zeitwerk'
require 'dry-struct'
require 'dry-types'
require 'json'
require 'yaml'
require 'openapi_parser'
require 'openapi3_parser'
require 'active_support'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/string'
require 'thor'
require 'deprecation'

# Help Zeitwerk find some of our classes
class CocinaModelsInflector < Zeitwerk::Inflector
  INFLECTIONS = {
    'doi' => 'DOI',
    'dro' => 'DRO',
    'request_dro' => 'RequestDRO',
    'dro_access' => 'DROAccess',
    'dro_structural' => 'DROStructural',
    'dro_with_metadata' => 'DROWithMetadata',
    'request_dro_structural' => 'RequestDROStructural',
    'rspec' => 'RSpec',
    'version' => 'VERSION'
  }.freeze

  def camelize(basename, _abspath)
    INFLECTIONS.fetch(basename) { super }
  end
end

loader = Zeitwerk::Loader.new
loader.inflector = CocinaModelsInflector.new
loader.push_dir(File.absolute_path("#{__FILE__}/../.."))
loader.ignore("#{__dir__}/rspec.rb")
loader.ignore("#{__dir__}/rspec/**/*.rb")
loader.setup

module Cocina
  # Provides Ruby objects for the repository and serializing them to/from JSON.
  module Models
    # TODO: Remove this when cocina-models 1.0.0 is released.
    DEPRECATED_CAMELCASE_METHODS = %i[
      accessContact accessTemplate adminMetadata appliesTo catalogLinks
      catalogRecordId cocinaVersion collectionsForRegistration
      controlledDigitalLending digitalLocation digitalRepository displayLabel
      disseminationWorkflow externalIdentifier groupedValue hasAdminPolicy
      hasAgreement hasMemberOrders hasMessageDigests hasMimeType isMemberOf
      marcEncodedData metadataStandard parallelContributor parallelEvent
      parallelValue partOfProject physicalLocation registrationWorkflow
      relatedResource releaseDate releaseTags sdrPreserve sourceId
      structuredValue useAndReproductionStatement valueAt valueLanguage
      valueScript viewingDirection
    ].freeze

    class Error < StandardError; end
    # Raised when the type attribute is not valid.
    class UnknownTypeError < Error; end

    # Raised when the type attribute is missing or an error occurs validating against openapi.
    class ValidationError < Error; end

    # Base class for Cocina Structs
    class Struct < Dry::Struct
      # TODO: Remove this when cocina-models 1.0.0 is released.
      extend Deprecation

      transform_keys(&:to_sym)
      schema schema.strict

      def self.new(attributes = default_attributes, safe = false, &block)
        super(underscore_attributes(attributes), safe, &block)
      end

      def self.underscore_attributes(attrs)
        attrs = attrs.with_indifferent_access
        # TODO: Remove this when cocina-models 1.0.0 is released.
        warn_about_deprecated_attributes!(attrs)
        attrs.deep_transform_keys(&:underscore)
      end

      # TODO: Remove this when cocina-models 1.0.0 is released.
      def self.warn_about_deprecated_attributes!(attrs)
        deprecated_attrs = deep_list_attrs(attrs).select { |attr| DEPRECATED_CAMELCASE_METHODS.include?(attr.to_sym) }
        return if deprecated_attrs.empty?

        Deprecation.warn(
          self,
          'camelCase attributes are deprecated and have been replaced with snake_case attributes. ' \
          "these will be removed in the cocina-models 1.0.0 release: #{deprecated_attrs.join(', ')}"
        )
      end
      private_class_method :warn_about_deprecated_attributes!

      # TODO: Remove this when cocina-models 1.0.0 is released.
      def self.deep_list_attrs(object, attrs = [])
        case object
        when Hash
          deep_list_attrs(object.values, attrs)

          attrs.concat(object.keys)
        when Array
          object.map { |value| deep_list_attrs(value, attrs) }
        end

        attrs.sort.uniq
      end
      private_class_method :deep_list_attrs

      # TODO: Remove this when cocina-models 1.0.0 is released.
      # Temporarily allow callers to send camelCase method names to avoid having to change the world
      def method_missing(method_name, *arguments, &block)
        if respond_to?(method_name.to_s.underscore)
          Deprecation.warn(
            self,
            "the `#{method_name}` attribute is deprecated and will be removed in the cocina-models 1.0.0 release"
          )
          public_send(method_name.to_s.underscore, *arguments, &block)
        else
          super
        end
      end

      # TODO: Remove this when cocina-models 1.0.0 is released.
      def respond_to_missing?(method_name, include_private = false)
        DEPRECATED_CAMELCASE_METHODS.include?(method_name) || super
      end

      def to_json(*)
        to_h
          .deep_transform_keys { |key| key.to_s.camelize(:lower) }
          .to_json
      end
    end

    # DRY Types
    module Types
      include Dry.Types()
    end

    ##
    # Alias for `Cocina::Models::Vocabulary.create`.
    #
    # @param (see Cocina::Models::Vocabulary#initialize)
    # @return [Class]
    # rubocop:disable Naming/MethodName
    def self.Vocabulary(uri)
      Vocabulary.create(uri)
    end
    # rubocop:enable Naming/MethodName

    # @param [Hash] dyn a ruby hash representation of the JSON serialization of a collection or DRO
    # @param [boolean] validate
    # @return [DRO,Collection,AdminPolicy]
    # @raises [UnknownTypeError] if a valid type is not found in the data
    # @raises [ValidationError] if a type field cannot be found in the data
    # @raises [ValidationError] if hash representation fails openapi validation
    def self.build(dyn, validate: true)
      clazz = case type_for(dyn)
              when *DRO::TYPES
                DRO
              when *Collection::TYPES
                Collection
              when *AdminPolicy::TYPES
                AdminPolicy
              else
                raise UnknownTypeError, "Unknown type: '#{dyn.with_indifferent_access.fetch('type')}'"
              end
      clazz.new(dyn, false, validate)
    end

    # @param [Hash] dyn a ruby hash representation of the JSON serialization of a request for a Collection or DRO
    # @param [boolean] validate
    # @return [RequestDRO,RequestCollection,RequestAdminPolicy]
    # @raises [UnknownTypeError] if a valid type is not found in the data
    # @raises [ValidationError] if a type field cannot be found in the data
    # @raises [ValidationError] if hash representation fails openapi validation
    def self.build_request(dyn, validate: true)
      clazz = case type_for(dyn)
              when *DRO::TYPES
                RequestDRO
              when *Collection::TYPES
                RequestCollection
              when *AdminPolicy::TYPES
                RequestAdminPolicy
              else
                raise UnknownTypeError, "Unknown type: '#{dyn.with_indifferent_access.fetch('type')}'"
              end
      clazz.new(dyn, false, validate)
    end

    # Coerces DROWithMetadata, CollectionWithMetadata, AdminPolicyWithMetadata to DRO, Collection, AdminPolicy
    # @param [DROWithMetadata,CollectionWithMetadata,AdminPolicyWithMetadata] cocina_object
    # @return [DRO,Collection,AdminPolicy]
    def self.without_metadata(cocina_object)
      build(cocina_object.to_h.except(:created, :modified, :lock))
    end

    # Adds metadata to a DRO, Collection, AdminPolicy
    # or updates for a DROWithMetadata, CollectionWithMetadata, AdminPolicyWithMetadata
    # @param [DROWithMetadata,CollectionWithMetadata,
    #           AdminPolicyWithMetadata,DRO,Collection,AdminPolicy] cocina_object
    # @param [String] lock
    # @param [DateTime] created
    # @param [DateTime] modified
    # @return [DROWithMetadata,CollectionWithMetadata,AdminPolicyWithMetadata]
    def self.with_metadata(cocina_object, lock, created: nil, modified: nil)
      props = cocina_object.to_h
      props[:created] = created.iso8601 if created
      props[:modified] = modified.iso8601 if modified
      props[:lock] = lock

      clazz = case cocina_object.type
              when *DRO::TYPES
                DROWithMetadata
              when *Collection::TYPES
                CollectionWithMetadata
              else
                AdminPolicyWithMetadata
              end
      clazz.new(props)
    end

    def self.type_for(dyn)
      dyn.with_indifferent_access.fetch('type')
    rescue KeyError
      raise ValidationError, 'Type field not found'
    end
    private_class_method :type_for
  end
end
