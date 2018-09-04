#!/bin/bash

#THIS PART IS RESPONSBLE FOR GETTING GROUPS DISCUSSION

#API QUERIES
#api/v1/groups/<group_id>/discussion_topics

echo "GETTING GROUP DISCUSSIONS..."
COURSE_ID=""
while read -r COURSE_ID; do
	mkdir -p $3\/$COURSE_ID/groups
	
	while read -r GROUP_ID; do
	
		mkdir -p $3\/$COURSE_ID\/groups/$GROUP_ID

		src/get_group_discussions/get_group_discussions_2.sh $1 $2 $3 $COURSE_ID $GROUP_ID &	
		
	done < "$3/$COURSE_ID/groups_ids.txt"


done < $3/course_ids.txt
wait
echo "GROUP DISCUSSIONS ARE DOWNLOADED"
echo