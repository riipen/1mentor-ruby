# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OneMentor::Client do
  subject { @client }

  before do
    @client = described_class.new(subdomain: 'subdomain', api_key: 'api_key')
  end

  describe '.initialize' do
    it 'returns a client object' do
      expect(@client).to be_a(described_class)
    end
  end

  describe '#connection' do
    it 'returns a connection instance' do
      expect(@client.connection).to be_a(OneMentor::Connection)
    end
  end
end