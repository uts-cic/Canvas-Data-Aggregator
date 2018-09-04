#!/bin/bash

#FOR EACH DISCUSSION WITHIN EACH COURSE
#RETRIVE CONTENT AS A JSON FILE

#USED API QUERIES:
#/api/v1/<course id>/discussion_topics/<discussion_id>/view
#/api/v1/<course id>/discussion_topics/<discussion_id>/entries


COURSE_ID=""
echo "GETTING DISCUSSION DETAILS..."
while read -r COURSE_ID; do
	mkdir -p $3\/$COURSE_ID/discussions
	
	while read -r DISCUSSION_ID; do
		read -r LAST_REPLY
		mkdir -p $3\/$COURSE_ID/discussions/$DISCUSSION_ID
		
		src/get_discussion_details/get_replies_ids_2.sh $1 $2 $3 $COURSE_ID $DISCUSSION_ID &
		


	done < "$3/$COURSE_ID/discussion_ids.txt"

done < $3/course_ids.txt
wait
echo "DISCUSSION DETAILS ARE DOWNLOADED"
echo