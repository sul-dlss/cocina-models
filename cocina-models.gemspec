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
  spec.homepage      = 'https://github.com/sul-dlss/cocina-models'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.4'

  spec.add_dependency 'activesupport'
  spec.add_dependency 'deprecation'
  spec.add_dependency 'dry-struct', '~> 1.0'
  spec.add_dependency 'dry-types', '~> 1.1'
  spec.add_dependency 'edtf' # used for date/time validation
  spec.add_dependency 'equivalent-xml' # for diffing MODS
  spec.add_dependency 'i18n' # for validating BCP 47 language tags, according to RFC 4646
  spec.add_dependency 'jsonpath' # used for date/time validation
  spec.add_dependency 'marc', '~> 1.3'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'openapi_parser', '~> 2.0'
  spec.add_dependency 'super_diff'
  spec.add_dependency 'thor'
  spec.add_dependency 'zeitwerk', '~> 2.1'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'committee'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.24'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'simplecov'
  spec.metadata['rubygems_mfa_required'] = 'true'
end
