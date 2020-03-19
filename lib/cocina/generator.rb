# frozen_string_literal: true

require 'zeitwerk'
require 'yaml'
require 'active_support/core_ext/string'
require 'thor'
require 'openapi3_parser'
require 'byebug'

loader = Zeitwerk::Loader.new
loader.push_dir(File.absolute_path("#{__FILE__}/../.."))
loader.setup

module Cocina
  # Module for generating Cocina models from openapi.
  module Generator
  end
end
