# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lightspeed_api/version'

Gem::Specification.new do |spec|
  spec.name          = "lightspeed_api"
  spec.version       = LightspeedApi::VERSION
  spec.authors       = ["Garrett Boone"]
  spec.email         = ["Boone.Garrett@gmail.com"]

  spec.summary       = %q{API Wrapper for Lightspeed POS}
  spec.homepage      = "https://www.github.com/booneteam/lightspeed_api"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'httparty', '~> 0.14', '>= 0.14.0'
  spec.add_runtime_dependency 'activerecord', '>= 3.0.0'
  spec.add_runtime_dependency 'shopify_api', '>= 4.3.7'
  # spec.add_runtime_dependency 'rails', '~> 5.0', '>= 5.0.1'


  spec.add_development_dependency 'httparty', '~> 0.14', '>= 0.14.0'
  spec.add_development_dependency 'activerecord', '>= 3.0.0'
  spec.add_development_dependency 'shopify_api', '>= 4.3.7'
  spec.add_development_dependency 'activerecord-nulldb-adapter'
  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "pry"
end
