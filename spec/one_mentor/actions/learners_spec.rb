# frozen_string_literal: true

require "spec_helper"

RSpec.describe OneMentor::Actions::Learners do
  subject { @client }

  before do
    @client = OneMentor::Client.new(subdomain: 'subdomain', api_key: "key")
  end

  describe "#learner_career_objectives" do
    it "issues the correct POST request to get a list of learner career objectives" do
      stub = stub_request(:post, "#{@client.base_url}/graphql")

      @client.learner_career_objectives('test@email.com')

      expect(stub).to have_been_requested
    end
  end

  describe "#learner_exists" do
    it "issues the correct POST request to get if a specific learner exists" do
      stub = stub_request(:post, "#{@client.base_url}/graphql")

      @client.learner_exists('test@email.com')

      expect(stub).to have_been_requested
    end
  end
end
