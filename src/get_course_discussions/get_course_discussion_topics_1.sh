#!/bin/bash

#THIS PART RETRIVE ALL DISSCUSSIONS BY COURSE
#THEN JSON FILE WITH ALL DISCUSSION PARCED TO GET ALL DISCUSSION IDS (SAME AS COURSES IDS)

#USED API QUERIES:
#/api/v1/<course_id>/enrollments
#/api/v1/<course_id>/discussion_topics
#/api/v1/<course_id>/recent_students

echo "GETTING DISCUSSIONS..."
COURSE_ID=""
while read -r COURSE_ID; do
	mkdir -p $3\/$COURSE_ID
	src/get_course_discussions/get_course_discussion_ids_2.sh $1 $2 $3 $COURSE_ID &
	
	
done < "$3/course_ids.txt"
wait

echo "DISCUSSIONS ARE DOWNLOADED"
echo