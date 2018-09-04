#!/bin/bash

#THIS ART IS RESPONSIBLE FOR GETTING GROUPS WITHIN COURSES
#AND CREATING GROUPS_IDS.TXT
#API QUERIES
#api/v1/courses/<course_id/groups

echo "GETTING GROUPS..."
COURSE_ID=""
while read -r COURSE_ID; do
	
	src/get_groups/get_groups_2.sh $1 $2 $3 $COURSE_ID &	
	

done < $3/course_ids.txt
wait
echo "GROUPS ARE DOWNLOADED"
echo