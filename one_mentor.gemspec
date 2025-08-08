# frozen_string_literal: true

require_relative 'lib/one_mentor/version'

Gem::Specification.new do |spec|
  spec.name          = 'one-mentor-ruby'
  spec.version       = OneMentor::VERSION
  spec.authors       = ['Riipen']
  spec.email         = ['help@riipen.com']

  spec.summary       = 'GraphQL client for the 1Mentor API'
  spec.description   = 'Ruby client for interacting with 1Mentor GraphQL endpoints, including learner and occupation related queries.'
  spec.homepage      = 'https://github.com/riipen/1mentor-ruby'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    Dir['lib/**/*', 'README.md', 'LICENSE']
  end
  spec.require_paths = ['lib']

  spec.required_ruby_version = Gem::Requirement.new('>= 2.7')

  spec.add_development_dependency 'rspec', '~> 3.12'
  spec.add_development_dependency 'rubocop', '~> 1.52.1'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.22.0'
  spec.add_development_dependency 'webmock', '~> 3.20'
end
