#!/bin/bash

#THIS PART RETRIVE ALL QUIZES IN EACH COURSE
#THEN JSON FILE WITH ALL QUIZES IS PARCED TO GET ALL QUIZES IDS (SAME AS COURSES IDS)

#USED API QUERIES:
#/api/v1/courses/<course_id>/quizzes

curl -s -H "Authorization: Bearer $1" "$2/courses/$4/quizzes?per_page=100" > $3\/$4/quizzes.json

echo -n "" > $3\/$4/quizzes_ids.txt
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
							echo -n "$line" >> $3\/$4/quizzes_ids.txt
							read -n1 line
						done
						echo >> $3\/$4/quizzes_ids.txt
						
					fi
				fi
				prevprevprev=$prevprev
				prevprev=$prev
				prev=$line
			done
done < "$3/$4/quizzes.json"