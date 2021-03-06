# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dfa/version'

Gem::Specification.new do |spec|
  spec.name          = 'dfa'
  spec.version       = DFA::VERSION
  spec.authors       = ['Yulia Oletskaya']
  spec.email         = ['yulia.oletskaya@gmail.com']

  spec.summary       = 'Deterministic finite automaton implementation'
  spec.homepage      = 'https://github.com/tuwukee/dfa'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry'
end
