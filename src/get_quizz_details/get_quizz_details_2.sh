#!/bin/bash

#FOR EACH QUIZ WITHIN EACH COURSE
#RETRIVE STATISTICS AS A JSON FILE

#USED API QUERIES:
#/api/v1/courses/<course_id>/quizzes/<quiz_id>/submissions
#/api/v1/courses/<course_id>/quizzes/>quiz_id>/statistics
#/api/v1/courses/<course_id>/quizzes/<quiz_id>/reports

curl -s -H "Authorization: Bearer $1" "$2/courses/$4/quizzes/$5/submissions?per_page=100" > $3\/$4/quizzes/$5/submissions.json
curl -s -H "Authorization: Bearer $1" "$2/courses/$4/quizzes/$5/statistics?per_page=100" > $3\/$4/quizzes/$5/statistics.json
curl -s -H "Authorization: Bearer $1" "$2/courses/$4/quizzes/$5/reports?per_page=100" > $3\/$4/quizzes/$5/reports.json