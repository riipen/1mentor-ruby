# frozen_string_literal: true

module OneMentor
  module Actions
    module Occupations
      def occupations_related(occupation)
        query = <<~GRAPHQL
          query GetRelatedOccupationsWithSpecializedSkills($occupation: NonEmptyString!) {
            getRelatedOccupationsWithSpecializedSkills(occupation: $occupation) {
              occupation
              relatedOccupations {
                occupation
                skillSet
              }
            }
          }
        GRAPHQL

        response = connection.post('graphql', {
                                     operationName: 'GetRelatedOccupationsWithSpecializedSkills',
                                     query: query,
                                     variables: {
                                       occupation: occupation
                                     }
                                   })

        response.dig('data', 'getRelatedOccupationsWithSpecializedSkills', 'relatedOccupations')
      end
    end
  end
end
