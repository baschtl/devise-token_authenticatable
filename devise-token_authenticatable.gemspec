# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise/token_authenticatable/version'

Gem::Specification.new do |spec|
  spec.name          = "devise-token_authenticatable"
  spec.version       = Devise::TokenAuthenticatable::VERSION.dup
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Sebastian Oelke"]
  spec.email         = ["dev@sohleeatsworld.de"]
  spec.description   = %q{This gem provides the extracted Token Authenticatable module of devise.
                          It enables the user to sign in via an authentication token. This token
                          can be given via a query string or HTTP Basic Authentication.}
  spec.summary       = %q{Provides authentication based on an authentication token for devise 3.2 and up.}
  spec.homepage      = "https://github.com/baschtl/devise-token_authenticatable"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_dependency "devise",                         "~> 3.5.0"

  spec.add_development_dependency "rails",              "~> 4.1.0"
  spec.add_development_dependency "rspec-rails",        "~> 3.0.2"
  spec.add_development_dependency "pry",                "~> 0.10.0"
  spec.add_development_dependency "factory_girl_rails", "~> 4.4.0"
  spec.add_development_dependency "timecop",            "~> 0.7.0"
  spec.add_development_dependency "bundler",            "~> 1.6"

  # Fix database connection with sqlite3 and jruby
  if    RUBY_ENGINE == 'ruby'
    spec.add_development_dependency "sqlite3",          "~> 1.3"
  elsif RUBY_ENGINE == 'jruby'
    spec.add_development_dependency "activerecord-jdbcsqlite3-adapter"
  end
end
