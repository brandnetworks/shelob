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

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"

  spec.add_runtime_dependency     "nokogiri"
end
