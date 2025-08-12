# frozen_string_literal: true

module OneMentor
  module Actions
    module Learners
      def learner_career_objectives(email)
        query = <<~GRAPHQL
          query GetLearnerCareerObjectivesAndSkillGaps($studentEmail: NonEmptyString!)
          {
            getLearnerCareerObjectivesAndSkillGaps(studentEmail: $studentEmail) {
              status
              message
              careerObjectives {
                occupation
              }
            }
          }
        GRAPHQL

        response = connection.post('graphql', {
                                     operationName: 'GetLearnerCareerObjectivesAndSkillGaps',
                                     query: query,
                                     variables: {
                                       studentEmail: email
                                     }
                                   })

        if response.dig('data', 'getLearnerCareerObjectivesAndSkillGaps', 'status')
          response.dig('data', 'getLearnerCareerObjectivesAndSkillGaps', 'careerObjectives')
        else
          false
        end
      end

      def learner_exists(email)
        query = <<~GRAPHQL
          query GetLearnerCareerObjectivesAndSkillGaps($studentEmail: NonEmptyString!)
          {
            getLearnerCareerObjectivesAndSkillGaps(studentEmail: $studentEmail) {
              status
              message
            }
          }
        GRAPHQL

        response = connection.post('graphql', {
                                     operationName: 'GetLearnerCareerObjectivesAndSkillGaps',
                                     query: query,
                                     variables: {
                                       studentEmail: email
                                     }
                                   })

        response.dig('data', 'getLearnerCareerObjectivesAndSkillGaps', 'status')
      end
    end
  end
end
