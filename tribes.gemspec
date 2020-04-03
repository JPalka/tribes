# frozen_string_literal: true

require_relative 'lib/tribes/version'

Gem::Specification.new do |spec|
  spec.name          = 'tribes'
  spec.version       = Tribes::VERSION
  spec.authors       = ['Anatoly Korenchkin']
  spec.email         = ['anatoly.korenchkin@interia.pl']

  spec.summary       = 'Gem goes brrr'
  spec.description   = 'Oof'
  spec.homepage      = 'https://github.com/JPalka/tribes'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  # spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/JPalka/tribes'
  # spec.metadata['changelog_uri'] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'solargraph', '~> 0.38'
  spec.add_development_dependency 'webmock', '~> 3.8'

  spec.add_runtime_dependency 'faraday', '~> 1.0'
  spec.add_runtime_dependency 'faraday_middleware', '~> 1.0'
end
