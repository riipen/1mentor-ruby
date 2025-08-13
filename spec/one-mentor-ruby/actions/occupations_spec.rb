# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OneMentor::Actions::Occupations do
  subject { @client }

  before do
    @client = OneMentor::Client.new(subdomain: 'subdomain', api_key: 'key')
  end

  describe '#occupations_related' do
    it 'issues the correct POST request to get related occupations' do
      stub = stub_request(:post, "#{@client.base_url}/graphql")
             .to_return(
               body: {
                 data: {
                   getRelatedOccupationsWithSpecializedSkills: {
                     status: true,
                     relatedOccupations: [{ foo: 'bar' }]
                   }
                 }
               }.to_json,
               headers: { 'Content-Type' => 'application/json' }
             )

      @client.occupations_related('test@email.com')

      expect(stub).to have_been_requested
    end
  end
end
