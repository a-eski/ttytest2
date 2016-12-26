# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ttytest/version'

Gem::Specification.new do |spec|
  spec.name          = "ttytest"
  spec.version       = TTYtest::VERSION
  spec.authors       = ["John Hawthorn"]
  spec.email         = ["john.hawthorn@gmail.com"]

  spec.summary       = %q{TTYtest is an integration test framework for interactive tty applications}
  spec.description   = %q{TTYtest allows running applications inside of a terminal emulator (like tmux) and making assertions on the output.}
  spec.homepage      = "https://github.com/jhawthorn/ttytest"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end