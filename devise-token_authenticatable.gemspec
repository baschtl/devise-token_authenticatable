# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise/token_authenticatable/version'

Gem::Specification.new do |spec|
  spec.name          = "devise-token_authenticatable"
  spec.version       = Devise::TokenAuthenticatable::VERSION.dup
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ["Sebastian Oelke"]
  spec.email         = ["soelke@babbel.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = "https://github.com/baschtl/devise-token_authenticatable"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]


  spec.add_dependency "devise", "~> 3.2.0"

  spec.add_development_dependency "activerecord",       ">= 3.2"
  spec.add_development_dependency "actionmailer",       ">= 3.2"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "factory_girl_rails"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "sqlite3",            "~> 1.3"
  spec.add_development_dependency "bundler",            "~> 1.3"
  spec.add_development_dependency "rake"
end
