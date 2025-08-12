# frozen_string_literal: true

require_relative 'lib/one_mentor/version'

Gem::Specification.new do |spec|
  spec.name = '1mentor-ruby'
  spec.version = OneMentor::VERSION
  spec.authors = ['Jordan Ell']
  spec.email = ['jordan.ell@riipen.com']

  spec.summary = 'An API client for 1Mentor in ruby.'
  spec.description = 'Access the 1Mentor REST API.'
  spec.homepage = 'https://github.com/riipen/1mentor-ruby'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/riipen/one-mentor-ruby/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 2.0', '>= 2.0.1'

  spec.metadata['rubygems_mfa_required'] = 'true'
end
