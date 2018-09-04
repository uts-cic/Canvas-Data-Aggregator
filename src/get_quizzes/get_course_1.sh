#!/bin/bash

#THIS PART RETRIVE ALL QUIZES IN EACH COURSE
#THEN JSON FILE WITH ALL QUIZES IS PARCED TO GET ALL QUIZES IDS (SAME AS COURSES IDS)

#USED API QUERIES:
#/api/v1/courses/<course_id>/quizzes

echo "GETTING QUIZZES..."
COURSE_ID=""
while read -r COURSE_ID; do
	
	src/get_quizzes/get_quizzes_2.sh $1 $2 $3 $COURSE_ID &

done < $3/course_ids.txt
wait

echo "QUIZZES ARE DOWNLOADED"
echo