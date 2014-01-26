# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unbundler/version'

Gem::Specification.new do |spec|
  spec.name          = "unbundler"
  spec.version       = Unbundler::VERSION
  spec.authors       = ["Stas Turlo"]
  spec.email         = ["stanislav.turlo@rightscale.com"]
  spec.description   = %q{Remove gems installed by bundler}
  spec.summary       = %q{Remove gems installed by bundler}
  spec.homepage      = ""
  spec.license       = "WTFPL"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", ">= 2.0.0"

  spec.add_dependency "bundler"
  spec.add_dependency "trollop"
end
