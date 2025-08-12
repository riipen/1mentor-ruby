# frozen_string_literal: true

require 'faraday'

module OneMentor
  class Connection
    def initialize(url, api_key, options = { timeout: 60 })
      @connection = Faraday.new(url:) do |builder|
        builder.request :json
        builder.headers[:accept] = "application/json"
        builder.headers['Content-Type'] = "application/json"
        builder.headers['x-api-key'] = api_key
        builder.response :json
        builder.response :logger, ::Logger.new(STDOUT), bodies: true
        builder.options.timeout = options[:timeout]
      end
    end

    def post(path, params = {})
      request(:post, path, params)
    end

    def request(method, path, params = {})
      puts 'method', method
      puts 'path', path
      puts 'params', params
      response = @connection.send(method, path, params)

      error = Error.from_response(response)

      raise error if error

      response.body
    end
  end
end
