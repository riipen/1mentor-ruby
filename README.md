# one-mentor-ruby

A GraphQL client for 1Mentor in ruby.

## Installation

Add to your `Gemfile`:

```ruby
gem 'one-mentor-ruby'
```

Then `bundle install`.

## Usage

### API Client

The 1Mentor API client uses an API key to authenticate API requests.

To obtain an API key talk to your 1Mentor representative.

Then you can create a 1MEntor API client.

```ruby
client = OneMentor::Client.new(
    api_key: 'my_key',
    subdomain: 'my-subdomain' # Your API instance subdomain
    timeout: 30, # Optional setting for timeouts of all requests (default 60)
)
```

### API Endpoints

1Mentor currently does not have any public facing documantion available, so support for endpoints is limited.

### List learner career objectives

Example: `client.learner_career_objectives(email@learner.com)`

Returns the following array

```json
[
  {},
  {},
  {},
]
```

### Check learner

Example: `client.learner_exists(email@learner.com)`

Returns `true` if the email address is tied to a learner account, `false` otherwise.

### Custom requests

Because the 1Mentor API is a wrapper on top of a GraphQL API, adhoc requests can be made
using the applicable GraphQL syntax.

Example:

```
query = <<~GRAPHQL
        query GetLearnerCareerObjectivesAndSkillGaps($studentEmail: NonEmptyString!)
        {
          getLearnerCareerObjectivesAndSkillGaps(studentEmail: $studentEmail) {
            status
            message
          }
        }
      GRAPHQL

client.request({
  operationName: 'GetLearnerCareerObjectivesAndSkillGaps',
  query:,
  variables: {
    studentEmail: email
  },
})
```

Custom requests will return the raw data structure from 1Mentor in this form:

```json
{
  "data": {
    "getLearnerCareerObjectivesAndSkillGaps": {
      "status": true,
      "message": ""
    }
  }
}
```

### Pagination

1Mentor does not currently support pagination.

### Errors

Any error code returned by the OneMentor API will result in one of the following expections

|Code|Exception|
|----|---------|
|400| OneMentor::BadRequest|
|401| OneMentor::Unauthorized|
|403| OneMentor::Forbidden|
|404| OneMentor::NotFound|
|429| OneMentor::TooManyRequests|
|400...499| OneMentor::ClientError|
|500| OneMentor::InternalServerError|
|502| OneMentor::BadGateway|
|503| OneMentor::ServiceUnavailable|
|500...599| OneMentor::ServerError|
