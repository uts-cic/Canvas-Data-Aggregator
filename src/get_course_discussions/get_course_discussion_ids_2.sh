#!/bin/bash

#THIS PART RETRIVE ALL DISSCUSSIONS BY COURSE
#THEN JSON FILE WITH ALL DISCUSSION PARCED TO GET ALL DISCUSSION IDS (SAME AS COURSES IDS)

#USED API QUERIES:
#/api/v1/<course_id>/enrollments
#/api/v1/<course_id>/discussion_topics
#/api/v1/<course_id>/recent_students

# $4 = COURSE_ID

curl -s -H "Authorization: Bearer $1" "$2/courses/$4/enrollments?per_page=100" > $3\/$4/enrollments.json
curl -s -H "Authorization: Bearer $1" "$2/courses/$4/discussion_topics?per_page=100" > $3\/$4/discussion_topics.json
curl -s -H "Authorization: Bearer $1" "$2/courses/$4/recent_students?per_page=100" > $3\/$4/recent_students.json
echo -n "" > $3\/$4/discussion_ids.txt
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
							echo -n "$line" >> $3\/$4/discussion_ids.txt
							read -n1 line
						done
						echo >> $3\/$4/discussion_ids.txt
						
						#LOOKING FOR A LAST REPLY TIME STAMP
					
						TIME_STAMP=""
						while read -n1 line; do
							if [ "$line" = "," ]
							then
								read -n2 line
								if [ "$line" = "\"l" ]
								then
									read -n15 line
									read -n1 line
									while [[ "$line" != "\"" ]]; do
										TIME_STAMP+=$line
										read -n1 line
									done
									echo -n "$TIME_STAMP" >> $3\/$4/discussion_ids.txt
									echo >> $3\/$4/discussion_ids.txt
									break
								fi
							fi
						done
						
					fi
				fi
				prevprevprev=$prevprev
				prevprev=$prev
				prev=$line
			done
done < "$3/$4/discussion_topics.json"