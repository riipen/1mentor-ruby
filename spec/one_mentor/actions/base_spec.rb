# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OneMentor::Actions::Base do
  subject { @skills }

  before do
    @client = OneMentor::Client.new(subdomain: 'subdomain', api_key: 'key')
  end

  describe '#request' do
    it 'issues the correct POST request' do
      body = {
        foo: 'bar'
      }

      stub = stub_request(:post, "#{@client.base_url}/graphql")
             .with(**body)

      @client.request(**body)

      expect(stub).to have_been_requested
    end
  end
end