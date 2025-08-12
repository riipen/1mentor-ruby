# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OneMentor::Connection do
  subject { @connection }

  before do
    @connection = described_class.new('https://foo.com/bar', 'key')
  end

  # Class Methods
  describe '.initialize' do
    it 'returns a connection object' do
      expect(@connection).to be_a(described_class)
    end
  end

  # Instance Methods
  describe '#post' do
    it 'issues a post request' do
      stub = stub_request(:post, 'https://foo.com/bar')

      @connection.post('/bar')

      expect(stub).to have_been_requested
    end
  end
end
