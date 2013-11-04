# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'srv_manager/version'

Gem::Specification.new do |spec|
  spec.name          = "srv_manager"
  spec.version       = SrvManager::VERSION
  spec.authors       = ["Gabriel Naiman"]
  spec.email         = ["gabynaiman@gmail.com"]
  spec.description   = 'Service admin and monitor'
  spec.summary       = 'Service admin and monitor'
  spec.homepage      = 'http://github.com/gabynaiman/srv_manager'
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor", "~> 0.18"
  spec.add_dependency "hirb", "~> 0.7"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
