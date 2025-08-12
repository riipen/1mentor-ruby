# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OneMentor::Error do
  subject { @error }

  before do
    @error = described_class.new
  end

  # Class Methods
  describe '.from_response' do
    before do
      @response = double
      @env = double

      allow(@response).to receive_messages(status: 200, env: @env, body: {})
      allow(@env).to receive_messages(method: 'GET', url: 'https://test.com')
    end

    it 'returns no error with status of 200' do
      allow(@response).to receive(:status).and_return(200)

      @error = described_class.from_response(@response)

      expect(@error).to equal(nil)
    end

    it 'returns BadRequest error with response status of 400' do
      allow(@response).to receive(:status).and_return(400)

      @error = described_class.from_response(@response)

      expect(@error).to be_a(OneMentor::BadRequest)
    end

    it 'returns Unauthorized error with response status of 401' do
      allow(@response).to receive(:status).and_return(401)

      @error = described_class.from_response(@response)

      expect(@error).to be_a(OneMentor::Unauthorized)
    end

    it 'returns Forbidden error with response status of 403' do
      allow(@response).to receive(:status).and_return(403)

      @error = described_class.from_response(@response)

      expect(@error).to be_a(OneMentor::Forbidden)
    end

    it 'returns NotFound error with response status of 404' do
      allow(@response).to receive(:status).and_return(404)

      @error = described_class.from_response(@response)

      expect(@error).to be_a(OneMentor::NotFound)
    end

    it 'returns TooManyRequests error with response status of 429' do
      allow(@response).to receive(:status).and_return(429)

      @error = described_class.from_response(@response)

      expect(@error).to be_a(OneMentor::TooManyRequests)
    end

    it 'returns ClientError error with response status > 400 and < 500' do
      allow(@response).to receive(:status).and_return(405)

      @error = described_class.from_response(@response)

      expect(@error).to be_a(OneMentor::ClientError)
    end

    it 'returns InternalServerError error with response status of 500' do
      allow(@response).to receive(:status).and_return(500)

      @error = described_class.from_response(@response)

      expect(@error).to be_a(OneMentor::InternalServerError)
    end

    it 'returns ServiceUnavailable error with response status of 503' do
      allow(@response).to receive(:status).and_return(503)

      @error = described_class.from_response(@response)

      expect(@error).to be_a(OneMentor::ServiceUnavailable)
    end

    it 'returns ServerError error with response status > 500 and < 600' do
      allow(@response).to receive(:status).and_return(505)

      @error = described_class.from_response(@response)

      expect(@error).to be_a(OneMentor::ServerError)
    end
  end

  describe '.initialize' do
    it 'returns a StandardError object' do
      expect(@error).to be_a(StandardError)
    end
  end
end
