# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-xyzqpods/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-xyzqpods'
  spec.version       = CocoapodsXyzqpods::VERSION
  spec.authors       = ['qiansicong']
  spec.email         = ['']
  spec.description   = %q{cocoapods-xyzqpods.}
  spec.summary       = %q{cocoapods-xyzqpods.}
  spec.homepage      = 'https://github.com/EXAMPLE/cocoapods-xyzqpods'
  spec.license       = 'MIT'

  # spec.files         = `git ls-files`.split($/) 
  spec.files = Dir['lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
