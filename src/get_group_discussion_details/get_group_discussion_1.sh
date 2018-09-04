#!/bin/bash

#THIS PART RETRIVES DATA FOR EACH DISCUSSION WITHIN A GROUPS

#QUERIES
#/api/v1/api/v1/groups/<group_id>/discussion_topics/<discussion_id>/view
#/api/v1/api/v1/groups/<group_id>/discussion_topics/<discussion_id>/entries

echo "GETTING GROUP DISCUSSION DETAILS..."
COURSE_ID=""
while read -r COURSE_ID; do
	while read -r GROUP_ID; do
		mkdir -p $3\/$COURSE_ID\/groups/$GROUP_ID/discussions
		
		while read -r DISCUSSION_ID; do
			read -r LAST_REPLY

			mkdir -p $3\/$COURSE_ID\/groups/$GROUP_ID/discussions/$DISCUSSION_ID

			src/get_group_discussion_details/get_group_discussion_details_2.sh $1 $2 $3 $COURSE_ID $GROUP_ID $DISCUSSION_ID &	
		
		done < "$3/$COURSE_ID/groups/$GROUP_ID/discussion_ids.txt"
		
	done < "$3/$COURSE_ID/groups_ids.txt"

done < $3/course_ids.txt
wait
echo "GETTING GROUP DISCUSSION ARE DOWNLOADED"
echo