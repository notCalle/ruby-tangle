# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tangle/version'

dev_deps = {
  'bundler' => '~> 2.2',
  'codecov' => '~> 0.5.0',
  'fasterer' => '~> 0.9.0',
  'pry' => '~> 0.14.0',
  'rake' => '~> 13.0',
  'rspec' => '~> 3.10',
  'rubocop' => '~> 1.15',
  'simplecov' => '~> 0.21.0'
}

Gem::Specification.new do |spec|
  spec.name          = 'tangle'
  spec.version       = Tangle::VERSION
  spec.authors       = ['Calle Englund']
  spec.email         = ['calle@discord.bofh.se']

  spec.summary       = 'Tangle implements graphs of things'
  spec.homepage      = 'https://github.com/notcalle/ruby-tangle'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.platform = Gem::Platform::RUBY
  spec.required_ruby_version = '~> 3.0'

  spec.add_dependency 'git-version-bump', '~> 0.17.0'

  dev_deps.each { |d| spec.add_development_dependency(*d) }
end
