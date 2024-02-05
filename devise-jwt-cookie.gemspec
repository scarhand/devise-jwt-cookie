lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devise/jwt/cookie/version'

Gem::Specification.new do |spec|
  spec.name          = "devise-jwt-cookie"
  spec.version       = Devise::JWT::Cookie::VERSION
  spec.authors       = ["Niels van der Zanden"]
  spec.email         = ["niels@pharynx.nl"]

  spec.summary       = %q{Cookie-based JWT authentication for devise}
  spec.description   = %q{Cookie-based JWT authentication for devise with configurable token revocation strategies}
  spec.homepage      = "https://github.com/scarhand/devise-jwt-cookie"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'devise-jwt', '~> 0.6'
  spec.add_dependency 'dry-auto_inject', '~> 0.6'
  spec.add_dependency 'dry-configurable', '~> 0.9'

  spec.add_development_dependency "bundler", "> 1"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "pry-byebug", "~> 3.7"
  # Needed to test the rails fixture application
  spec.add_development_dependency 'rails', '~> 5.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3'
  spec.add_development_dependency 'rspec-rails', '~> 3.5'
  # Test reporting
  spec.add_development_dependency 'simplecov', '0.17'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'
end
