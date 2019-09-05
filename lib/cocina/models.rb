require "cocina/models/version"

require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.setup # ready!

module Cocina
  module Models
    class Error < StandardError; end
    # Your code goes here...
  end
end
