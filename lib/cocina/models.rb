# frozen_string_literal: true

require 'cocina/models/version'
require 'zeitwerk'
require 'dry-struct'
require 'dry-types'

class CocinaModelsInflector < Zeitwerk::Inflector
  def camelize(basename, _abspath)
    case basename
    when 'dro'
      'DRO'
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
  module Models
    class Error < StandardError; end
    # Your code goes here...
  end
end
