# frozen_string_literal: true

require 'rspec'
require 'webmock/rspec'

require_relative '../lib/one_mentor'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
