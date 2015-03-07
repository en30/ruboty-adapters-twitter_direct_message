# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "ruboty-adapters-twitter_direct_message"
  spec.version       = "0.0.1"
  spec.authors       = ["en30"]
  spec.email         = ["en30.git@gmail.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = %q{A Ruboty adapter for twitter direct messages.}
  spec.homepage      = "https://github.com/en30/ruboty-adapters-twitter_direct_message"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "mem"
  spec.add_dependency "ruboty"
  spec.add_dependency "activesupport"
  spec.add_dependency "twitter", ">= 5.0.0"
  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
