# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shelob/version'

Gem::Specification.new do |spec|
  spec.name          = "shelob"
  spec.version       = Shelob::VERSION
  spec.homepage      = 'https://github.com/bmnick/shelob'
  spec.authors       = ["Benjamin Nicholas"]
  spec.email         = ["bnicholas@brandnetworksinc.com"]
  spec.description   = %q{A giant spider that starts on a given page, finds all links on the page, ensure they resolve, and recurses if the link is underneath the starting url}
  spec.summary       = %q{Spider a site and check links}
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # Automation
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.1"
  spec.add_development_dependency "guard", "~> 2.2"
  spec.add_development_dependency "guard-minitest", "~> 2.1"

  # Testing tools
  spec.add_development_dependency "minitest", "~> 5.2"
  spec.add_development_dependency "webmock", "~> 1.16"

  # Runtime dependencies
  spec.add_runtime_dependency     "nokogiri", "~> 1.6"
  spec.add_runtime_dependency     "methadone", "~> 1.3"
end
