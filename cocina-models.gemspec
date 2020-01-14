# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocina/models/version'

Gem::Specification.new do |spec|
  spec.name          = 'cocina-models'
  spec.version       = Cocina::Models::VERSION
  spec.authors       = ['Justin Coyne']
  spec.email         = ['jcoyne@justincoyne.com']

  spec.summary       = 'Data models for the SDR'
  spec.description   = 'SDR data models that can be validated'
  spec.homepage      = 'https://github.com/sul-dlss-labs/cocina-models'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'dry-struct', '~> 1.0'
  spec.add_dependency 'dry-types', '~> 1.1'
  spec.add_dependency 'zeitwerk', '~> 2.1'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.74.0'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
end
