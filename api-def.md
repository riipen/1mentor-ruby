1Mentor API Connection


Base URL

https://virginia-api.1mentor.io/external/graphql

Authentication

All requests require the following header:
x-api-key: <your_api_key>

Overview

This GraphQL API provides access to learner-related data and occupational insights. All 5
functionalities described below are handled through two GraphQL queries:

1. getLearnerCareerObjectivesAndSkillGaps — for learner email, career objectives,
and skill gaps.
2. getRelatedOccupationsWithSpecializedSkills — for related occupations and
skill sets.

1. Check if Student Email is Registered

Query

query GetLearnerCareerObjectivesAndSkillGaps($studentEmail: NonEmptyString!)
{
getLearnerCareerObjectivesAndSkillGaps(studentEmail: $studentEmail) {
status
message
}
Variables
}
{
}
"studentEmail": "{{LEARNER_EMAIL}}"
Successful Response (Registered)
{
"data": {
"getLearnerCareerObjectivesAndSkillGaps": {
"status": true,
"message": ""
}
}
}
{
Error Response (Not Registered)
"data": {
"getLearnerCareerObjectivesAndSkillGaps": {
"status": false,
"message": "Learner not found"
}
}
}

2. Get Learner Career Objectives

Query

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
Successful Response
{
"data": {
"getLearnerCareerObjectivesAndSkillGaps": {
"status": true,
"message": ""
,
"careerObjectives": [
{ "occupation": "Occupation 1" },
{ "occupation": "Occupation 2" },
{ "occupation": "Occupation 3" }
]
}
}
}
{
Response if Not Registered
"data": {
"getLearnerCareerObjectivesAndSkillGaps": {
"status": false,
"message": "Learner not found",
"careerObjectives": []
}
}
}

3. Get Learner Career Objectives with Skill Gaps

Query

query GetLearnerCareerObjectivesAndSkillGaps($studentEmail: NonEmptyString!)
{
getLearnerCareerObjectivesAndSkillGaps(studentEmail: $studentEmail) {
status
message
careerObjectives {
occupation
gaps
}
}
Successful Response
}
{
"data": {
"getLearnerCareerObjectivesAndSkillGaps": {
"status": true,
"message": ""
,
"careerObjectives": [
{
"occupation": "Occupation 1",
"gaps": ["Skill A", "Skill B", "Skill C", "Skill D", "Skill E"]
},
{
"occupation": "Occupation 2",
"gaps": ["Skill F", "Skill G", "Skill H", "Skill I", "Skill J"]
},
{
"occupation": "Occupation 3",
"gaps": ["Skill K", "Skill L", "Skill M", "Skill N", "Skill O"]
}
]
}
}
}
Response if Not Registered
{
"data": {
"getLearnerCareerObjectivesAndSkillGaps": {
"status": false,
"message": "Learner not found",
"careerObjectives": []
}
}
}

Note: Only up to 5 specialized skill gaps per occupation are returned.

4. Get Related Occupations by Occupation Name

Query

query GetRelatedOccupationsWithSpecializedSkills($occupation:
NonEmptyString!) {
getRelatedOccupationsWithSpecializedSkills(occupation: $occupation) {
occupation
relatedOccupations {
occupation
}
}
Variables
Successful Response
}
{
}
{
"occupation": "{{OCCUPATION}}"
"data": {
"getRelatedOccupationsWithSpecializedSkills": {
"occupation": "Occupation A",
"relatedOccupations": [
{ "occupation": "Occupation B" },
{ "occupation": "Occupation C" },
{ "occupation": "Occupation D" },
{ "occupation": "Occupation E" },
{ "occupation": "Occupation F" }
]
}
}
}
{
No Match Response
"data": {
"getRelatedOccupationsWithSpecializedSkills": {
"occupation": "invalid-occupation-name",
"relatedOccupations": []
}
}
}

5. Get Related Occupations with Skill Sets

Query

query GetRelatedOccupationsWithSpecializedSkills($occupation:
NonEmptyString!) {
getRelatedOccupationsWithSpecializedSkills(occupation: $occupation) {
occupation
relatedOccupations {
occupation
skillSet
}
}
}
Successful Response
{
"data": {
"getRelatedOccupationsWithSpecializedSkills": {
"occupation": "Occupation A",
"relatedOccupations": [
{
"occupation": "Occupation B",
"skillSet": ["Skill A1", "Skill A2", "Skill A3", "Skill A4", "Skill
A5"]
},
{
"occupation": "Occupation C",
"skillSet": ["Skill B1", "Skill B2", "Skill B3", "Skill B4", "Skill
B5"]
},
{
"occupation": "Occupation D",
"skillSet": ["Skill C1", "Skill C2", "Skill C3", "Skill C4", "Skill
C5"]
},
{
"occupation": "Occupation E",
"skillSet": ["Skill D1", "Skill D2", "Skill D3", "Skill D4", "Skill
D5"]
},
{
"occupation": "Occupation F",
"skillSet": ["Skill E1", "Skill E2", "Skill E3", "Skill E4", "Skill
E5"]
}
]
}
}
}
Note: Each related occupation includes a skillSet of up to 5 specialized skills.
