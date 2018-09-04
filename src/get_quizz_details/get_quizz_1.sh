#!/bin/bash

#FOR EACH QUIZ WITHIN EACH COURSE
#RETRIVE STATISTICS AS A JSON FILE

#USED API QUERIES:
#/api/v1/courses/<course_id>/quizzes/<quiz_id>/submissions
#/api/v1/courses/<course_id>/quizzes/>quiz_id>/statistics
#/api/v1/courses/<course_id>/quizzes/<quiz_id>/reports


echo "GETTING QUIZZ DETAILS..."
COURSE_ID=""
while read -r COURSE_ID; do
	mkdir -p $3\/$COURSE_ID/quizzes
	while read -r QUIZZ_ID; do

		mkdir -p "$3/$COURSE_ID/quizzes/$QUIZZ_ID"
		src/get_quizz_details/get_quizz_details_2.sh $1 $2 $3 $COURSE_ID $QUIZZ_ID &			
	
	done < "$3/$COURSE_ID/quizzes_ids.txt"


done < $3/course_ids.txt
wait
echo "QUIZZ DETAILS ARE DOWNLOADED"
echo