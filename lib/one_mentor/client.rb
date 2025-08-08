# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'

module OneMentor
  # GraphQL client for 1Mentor API.
  class Client
    DEFAULT_TIMEOUT = 30

    attr_reader :subdomain, :api_key, :base_url

    def initialize(subdomain:, api_key:, timeout: DEFAULT_TIMEOUT)
      raise ArgumentError, 'subdomain required' if subdomain.to_s.strip.empty?
      raise ArgumentError, 'api_key required' if api_key.to_s.strip.empty?

      @subdomain = subdomain.strip
      @api_key = api_key
      @base_url = "https://#{@subdomain}.1mentor.io/external/graphql"
      @timeout = timeout
    end

    # 1. Check if Student Email is Registered
    # Returns [status(Boolean), message(String)] or raises on transport error.
    def learner_registered?(email)
      data = fetch_learner(email, fields: 'status message')
      resp = data.fetch('getLearnerCareerObjectivesAndSkillGaps')
      [resp['status'], resp['message']]
    end

    # 2. Get Learner Career Objectives (list of occupations)
    def learner_career_objectives(email)
      data = fetch_learner(email, fields: 'status message careerObjectives { occupation }')
      resp = data['getLearnerCareerObjectivesAndSkillGaps']
      return [] unless resp['status']
      (resp['careerObjectives'] || []).map { |o| o['occupation'] }
    end

    # 3. Get Learner Career Objectives with Skill Gaps
    # Returns array of { 'occupation' => String, 'gaps' => [String] }
    def learner_career_objectives_with_skill_gaps(email)
      data = fetch_learner(email, fields: 'status message careerObjectives { occupation gaps }')
      resp = data['getLearnerCareerObjectivesAndSkillGaps']
      return [] unless resp['status']
      resp['careerObjectives'] || []
    end

    # 4. Get Related Occupations by Occupation Name
    def related_occupations(occupation)
      data = fetch_related(occupation, fields: 'occupation relatedOccupations { occupation }')
      resp = data['getRelatedOccupationsWithSpecializedSkills']
      (resp['relatedOccupations'] || []).map { |o| o['occupation'] }
    end

    # 5. Get Related Occupations with Skill Sets
    def related_occupations_with_skill_sets(occupation)
      data = fetch_related(occupation, fields: 'occupation relatedOccupations { occupation skillSet }')
      resp = data['getRelatedOccupationsWithSpecializedSkills']
      resp['relatedOccupations'] || []
    end

    private

    def fetch_learner(email, fields:)
      query = <<~GRAPHQL
        query GetLearnerCareerObjectivesAndSkillGaps($studentEmail: NonEmptyString!) {
          getLearnerCareerObjectivesAndSkillGaps(studentEmail: $studentEmail) {
            #{fields}
          }
        }
      GRAPHQL
      execute(query: query, variables: { studentEmail: email })['data']
    end

    def fetch_related(occupation, fields:)
      query = <<~GRAPHQL
        query GetRelatedOccupationsWithSpecializedSkills($occupation: NonEmptyString!) {
          getRelatedOccupationsWithSpecializedSkills(occupation: $occupation) {
            #{fields}
          }
        }
      GRAPHQL
      execute(query: query, variables: { occupation: occupation })['data']
    end

    def execute(query:, variables: {})
      uri = URI.parse(base_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'
      http.read_timeout = @timeout
      req = Net::HTTP::Post.new(uri.request_uri)
      req['Content-Type'] = 'application/json'
      req['x-api-key'] = api_key
      req.body = JSON.dump({ query: query, variables: variables })
      res = http.request(req)
      unless res.is_a?(Net::HTTPSuccess)
        raise OneMentor::Error, "HTTP #{res.code}: #{res.body}"
      end
      parsed = JSON.parse(res.body)
      if parsed['errors']
        raise OneMentor::Error, parsed['errors'].map { |e| e['message'] }.join('; ')
      end
      parsed
    rescue JSON::ParserError => e
      raise OneMentor::Error, "Invalid JSON response: #{e.message}"
    rescue StandardError => e
      raise OneMentor::Error, e.message
    end
  end
end
