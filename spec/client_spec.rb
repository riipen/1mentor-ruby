# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OneMentor::Client do
  let(:subdomain) { 'virginia' }
  let(:api_key) { 'test-key' }
  let(:client) { described_class.new(subdomain: subdomain, api_key: api_key) }
  let(:base_url) { "https://#{subdomain}.1mentor.io/external/graphql" }

  def stub_graphql(body_hash, status: 200)
    stub_request(:post, base_url)
      .with(headers: { 'Content-Type' => 'application/json', 'x-api-key' => api_key })
      .to_return(status: status, body: JSON.dump(body_hash), headers: { 'Content-Type' => 'application/json' })
  end

  describe '#learner_registered?' do
    it 'returns true when learner exists' do
      stub_graphql({ 'data' => { 'getLearnerCareerObjectivesAndSkillGaps' => { 'status' => true, 'message' => '' } } })
      status, message = client.learner_registered?('user@example.com')
      expect(status).to be true
      expect(message).to eq ''
    end

    it 'returns false when learner not found' do
      stub_graphql({ 'data' => { 'getLearnerCareerObjectivesAndSkillGaps' => { 'status' => false, 'message' => 'Learner not found' } } })
      status, message = client.learner_registered?('missing@example.com')
      expect(status).to be false
      expect(message).to eq 'Learner not found'
    end
  end

  describe '#learner_career_objectives' do
    it 'returns occupations when status true' do
      stub_graphql({ 'data' => { 'getLearnerCareerObjectivesAndSkillGaps' => { 'status' => true, 'message' => '', 'careerObjectives' => [ { 'occupation' => 'Occupation 1' }, { 'occupation' => 'Occupation 2' } ] } } })
      list = client.learner_career_objectives('user@example.com')
      expect(list).to eq ['Occupation 1', 'Occupation 2']
    end

    it 'returns empty when status false' do
      stub_graphql({ 'data' => { 'getLearnerCareerObjectivesAndSkillGaps' => { 'status' => false, 'message' => 'Learner not found', 'careerObjectives' => [] } } })
      list = client.learner_career_objectives('missing@example.com')
      expect(list).to eq []
    end
  end

  describe '#learner_career_objectives_with_skill_gaps' do
    it 'returns occupations with gaps' do
      stub_graphql({ 'data' => { 'getLearnerCareerObjectivesAndSkillGaps' => { 'status' => true, 'message' => '', 'careerObjectives' => [ { 'occupation' => 'Occupation 1', 'gaps' => %w[SkillA SkillB] } ] } } })
      list = client.learner_career_objectives_with_skill_gaps('user@example.com')
      expect(list).to eq([{ 'occupation' => 'Occupation 1', 'gaps' => %w[SkillA SkillB] }])
    end
  end

  describe '#related_occupations' do
    it 'returns related occupations' do
      stub_graphql({ 'data' => { 'getRelatedOccupationsWithSpecializedSkills' => { 'occupation' => 'Occupation A', 'relatedOccupations' => [ { 'occupation' => 'Occupation B' }, { 'occupation' => 'Occupation C' } ] } } })
      list = client.related_occupations('Occupation A')
  expect(list).to eq ['Occupation B', 'Occupation C']
    end
  end

  describe '#related_occupations_with_skill_sets' do
    it 'returns related occupations with skill sets' do
      stub_graphql({ 'data' => { 'getRelatedOccupationsWithSpecializedSkills' => { 'occupation' => 'Occupation A', 'relatedOccupations' => [ { 'occupation' => 'Occupation B', 'skillSet' => %w[Skill1 Skill2] } ] } } })
      list = client.related_occupations_with_skill_sets('Occupation A')
      expect(list).to eq([{ 'occupation' => 'Occupation B', 'skillSet' => %w[Skill1 Skill2] }])
    end
  end

  describe 'error handling' do
    it 'raises on http error' do
      stub_request(:post, base_url).to_return(status: 500, body: 'oops')
      expect { client.related_occupations('X') }.to raise_error(OneMentor::Error, /HTTP 500/)
    end

    it 'raises on graphql errors' do
      stub_graphql({ 'errors' => [ { 'message' => 'Bad query' } ] })
      expect { client.related_occupations('X') }.to raise_error(OneMentor::Error, /Bad query/)
    end
  end
end
