# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth/intercom/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-intercom"
  spec.version       = OmniAuth::Intercom::VERSION
  spec.authors       = ["Kevin Antoine"]
  spec.email         = ["kevin.antoine@intercom.io"]

  spec.summary  = 'Intercom OAuth2 Strategy for OmniAuth'
  spec.homepage = 'https://github.com/intercom/omniauth-intercom'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'omniauth-oauth2', '>= 1.2'
  spec.add_runtime_dependency 'base64'

  spec.add_development_dependency "rake", "~> 13.2"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rack", "~> 3.1"
end
