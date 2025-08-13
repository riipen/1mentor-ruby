# frozen_string_literal: true

module OneMentor
  class Client
    include OneMentor::Actions::Base
    include OneMentor::Actions::Learners
    include OneMentor::Actions::Occupations

    attr_reader :subdomain, :api_key, :base_url

    def initialize(subdomain:, api_key:)
      @subdomain  = subdomain
      @api_key    = api_key

      @base_url = "https://#{subdomain}.1mentor.io/external"
    end

    def connection
      Connection.new(@base_url, @api_key)
    end
  end
end
