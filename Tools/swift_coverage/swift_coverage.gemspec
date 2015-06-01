# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'swift_coverage/version'

Gem::Specification.new do |spec|
  spec.name          = "swift_coverage"
  spec.version       = SwiftCoverage::VERSION
  spec.authors       = ["kishikawa katsumi"]
  spec.email         = ["kishikawakatsumi@mac.com"]

  spec.summary       = %q{Swift code coverage report tool}
  spec.description   = %q{Swift code coverage report tool}
  spec.homepage      = "http://github.com/kishikawakatsumi/swift_coverage"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "commander"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
