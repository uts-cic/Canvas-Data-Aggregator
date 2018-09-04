#!/bin/bash

#THIS ART IS RESPONSIBLE FOR GETTING GROUPS WITHIN COURSES
#AND CREATING GROUPS_IDS.TXT
#API QUERIES
#api/v1/courses/<course_id/groups

curl -s -H "Authorization: Bearer $1" "$2/courses/$4/groups?per_page=100" > $3\/$4/groups.json

echo -n "" > $3\/$4/groups_ids.txt
prevprevprev=""
prevprev=""
prev=""
while IFS='' read -n1 line || [[ -n "$line" ]]; do
			prev=$line
			while read -n1 line; do
				if [ "$line" = "i" ] && [ "$prevprev" = "{" ] && [ "$prevprevprev" != ":" ]
					then
					read -n3 line
					if [ "$line" = "d\":" ]
					then
						re="^[0-9]+$"
						read -n1 line
						while [[ $line =~ $re ]]; do
							echo -n "$line" >> $3\/$4/groups_ids.txt
							read -n1 line
						done
						echo >> $3\/$4/groups_ids.txt
						
					fi
				fi
				prevprevprev=$prevprev
				prevprev=$prev
				prev=$line
			done
done < "$3/$4/groups.json"