module OneMentor
  module Actions
    module Base
      def request(body)
        connection.post('graphql', body)
      end
    end
  end
end