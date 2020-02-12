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
    when 'dro_builder'
      'DROBuilder'
    when 'request_dro'
      'RequestDRO'
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

    # @param [Hash] dyn a ruby hash representation of the JSON serialization of a collection or DRO
    # @return [DRO,Collection]
    # @raises [UnknownTypeError] if a valid type is not found in the data
    # @raises [KeyError] if a type field cannot be found in the data
    def self.build(dyn)
      case dyn.fetch('type')
      when *DRO::TYPES
        DRO.from_dynamic(dyn)
      when *Collection::TYPES
        Collection.from_dynamic(dyn)
      when *AdminPolicy::TYPES
        AdminPolicy.from_dynamic(dyn)
      else
        raise UnknownTypeError, "Unknown type: '#{dyn.fetch('type')}'"
      end
    end
  end
end
