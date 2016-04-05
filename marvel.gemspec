# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marvel/version'

Gem::Specification.new do |spec|
  spec.name          = "marvel-api"
  spec.version       = Marvel::VERSION
  spec.authors       = ["Ritesh Choudhary", "Mukesh Patel"]
  spec.email         = ["ritesh.strive@gmail.com", "mukesh.strive@gmail.com"]
  spec.description   = %q{Ruby Client for Marvel API's just add gem in your project for using the Marvel API.}
  spec.summary       = %q{Ruby client for the Marvel API.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  #spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 3"
end
