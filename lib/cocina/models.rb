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

# Help Zeitwerk find some of our classes
class CocinaModelsInflector < Zeitwerk::Inflector
  INFLECTIONS = {
    'doi' => 'DOI',
    'dro' => 'DRO',
    'request_dro' => 'RequestDRO',
    'dro_access' => 'DROAccess',
    'dro_structural' => 'DROStructural',
    'request_dro_structural' => 'RequestDROStructural',
    'version' => 'VERSION'
  }.freeze

  def camelize(basename, _abspath)
    INFLECTIONS.fetch(basename) { super }
  end
end

loader = Zeitwerk::Loader.new
loader.inflector = CocinaModelsInflector.new
loader.push_dir(File.absolute_path("#{__FILE__}/../.."))
loader.setup

module Cocina
  # Provides Ruby objects for the repository and serializing them to/from JSON.
  module Models
    class Error < StandardError; end
    # Raised when the type attribute is not valid.
    class UnknownTypeError < Error; end

    # Raised when an error occurs validating against openapi.
    class ValidationError < Error; end

    # Base class for Cocina Structs
    class Struct < Dry::Struct
      transform_keys(&:to_sym)
      schema schema.strict
    end

    # DRY Types
    module Types
      include Dry.Types()
    end

    # @param [Hash] dyn a ruby hash representation of the JSON serialization of a collection or DRO
    # @param [boolean] validate
    # @return [DRO,Collection,AdminPolicy]
    # @raises [UnknownTypeError] if a valid type is not found in the data
    # @raises [KeyError] if a type field cannot be found in the data
    # @raises [ValidationError] if hash representation fails openapi validation
    def self.build(dyn, validate: true)
      clazz = case dyn.fetch('type')
              when *DRO::TYPES
                DRO
              when *Collection::TYPES
                Collection
              when *AdminPolicy::TYPES
                AdminPolicy
              else
                raise UnknownTypeError, "Unknown type: '#{dyn.fetch('type')}'"
              end
      clazz.new(dyn, false, validate)
    end

    # @param [Hash] dyn a ruby hash representation of the JSON serialization of a request for a Collection or DRO
    # @param [boolean] validate
    # @return [RequestDRO,RequestCollection,RequestAdminPolicy]
    # @raises [UnknownTypeError] if a valid type is not found in the data
    # @raises [KeyError] if a type field cannot be found in the data
    # @raises [ValidationError] if hash representation fails openapi validation
    def self.build_request(dyn, validate: true)
      clazz = case dyn.fetch('type')
              when *DRO::TYPES
                RequestDRO
              when *Collection::TYPES
                RequestCollection
              when *AdminPolicy::TYPES
                RequestAdminPolicy
              else
                raise UnknownTypeError, "Unknown type: '#{dyn.fetch('type')}'"
              end
      clazz.new(dyn, false, validate)
    end
  end
end
