# frozen_string_literal: true

require 'cocina/models/version'
require 'zeitwerk'
require 'dry-struct'
require 'dry-types'
require 'json'

# Help Zeitwerk find some of our classes
class CocinaModelsInflector < Zeitwerk::Inflector
  def camelize(basename, _abspath)
    case basename
    when 'dro'
      'DRO'
    when 'request_dro'
      'RequestDRO'
    when 'dro_structural'
      'DROStructural'
    when 'request_dro_structural'
      'RequestDROStructural'
    when 'version'
      'VERSION'
    else
      super
    end
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
    # @return [DRO,Collection]
    # @raises [UnknownTypeError] if a valid type is not found in the data
    # @raises [KeyError] if a type field cannot be found in the data
    def self.build(dyn)
      case dyn.fetch('type')
      when *DRO::TYPES
        DRO.new(dyn)
      when *Collection::TYPES
        Collection.new(dyn)
      when *AdminPolicy::TYPES
        AdminPolicy.new(dyn)
      else
        raise UnknownTypeError, "Unknown type: '#{dyn.fetch('type')}'"
      end
    end

    # @param [Hash] dyn a ruby hash representation of the JSON serialization of a request for a Collection or DRO
    # @return [RequestDRO,RequestCollection,RequestAdminPolicy]
    # @raises [UnknownTypeError] if a valid type is not found in the data
    # @raises [KeyError] if a type field cannot be found in the data
    def self.build_request(dyn)
      case dyn.fetch('type')
      when *DRO::TYPES
        RequestDRO.new(dyn)
      when *Collection::TYPES
        RequestCollection.new(dyn)
      when *AdminPolicy::TYPES
        RequestAdminPolicy.new(dyn)
      else
        raise UnknownTypeError, "Unknown type: '#{dyn.fetch('type')}'"
      end
    end
  end
end
