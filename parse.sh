#!/bin/bash



#READING CONFIG FILE
#FIRST STEP OF ANY SCRIPT
#INITIAL SETTINGS
ACCESS_TOKEN=""
DOMAIN=""
DATE=$(date +%Y%m%d%H%M%S)


while true; do
	read -r DOMAIN
	read -r ACCESS_TOKEN
	break
done < config.txt

DOMAIN+="/api/v1/"



#RUNNING CURL 
#WE NEED QUERY AS FOLLOWING EXAMPLE
#WE NEED TO RUN SIMPLE QUERY curl -H "Authorization: Bearer <ACCESS_TOKEN>" "<DOMAIN> + <CANVAS_API_REQUEST>" > <OUTPUT_FILE_NAME.JSON>
#EXAMPLE (NOT REAL TOKEN)
#curl -H "Authorization: Bearer 45745745~njshfg767BHFgui" "https://uts-dev.instructure.com/api/v1/courses>" > courses.json
#CURL WILL USE ACCESS_TOKEN AND DOMAIN VARIABLES
#THE OUTCOME WILL BE STORES IN A .json FILE

#USED API QUERIES:
#/api/v1/courses

mkdir $DATE
curl -H "Authorization: Bearer $ACCESS_TOKEN" "$DOMAIN/courses" > $DATE/courses.json


#AFTER WE HAVE JSON FILE FROM CANVAS WE NEED ALL AVAILABLE COURSE IDS
#PARSE COURSE.JSON FOR ALL COURSES IDS

while IFS='' read -n1 line || [[ -n "$line" ]]; do
	echo -n "" > $DATE/course_ids.txt
	while read -n1 line; do
		if [ "$line" = "i" ] && [ "$prevprev" = "{" ]
			then
			read -n3 line
			if [ "$line" = "d\":" ]
			then
				re="^[0-9]+$"
				read -n1 line
				while [[ $line =~ $re ]]; do
					echo -n "$line" >> $DATE/course_ids.txt
					read -n1 line
				done
				echo >> $DATE/course_ids.txt
			fi
		fi
		prevprev=$prev
		prev=$line
	done
done < "$DATE/courses.json"



#THIS PART RETRIVE ALL DISSCUSSIONS BY COURSE
#THEN JSON FILE WITH ALL DISCUSSION PARCED TO GET ALL DISCUSSION IDS (SAME AS COURSES IDS)

#USED API QUERIES:
#/api/v1/<course_id>/enrollments
#/api/v1/<course_id>/discussion_topics
#/api/v1/<course_id>/recent_students

COURSE_ID=""
while read -r COURSE_ID; do
	mkdir $DATE\/$COURSE_ID
	
	curl -H "Authorization: Bearer $ACCESS_TOKEN" "$DOMAIN/courses/$COURSE_ID/enrollments" > $DATE\/$COURSE_ID/enrollments.json
	curl -H "Authorization: Bearer $ACCESS_TOKEN" "$DOMAIN/courses/$COURSE_ID/discussion_topics" > $DATE\/$COURSE_ID/discussion_topics.json
	curl -H "Authorization: Bearer $ACCESS_TOKEN" "$DOMAIN/courses/$COURSE_ID/recent_students" > $DATE\/$COURSE_ID/recent_students.json

	echo -n "" > $DATE\/$COURSE_ID/discussion_ids.txt
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
								echo -n "$line" >> $DATE\/$COURSE_ID/discussion_ids.txt
								read -n1 line
							done
							echo >> $DATE\/$COURSE_ID/discussion_ids.txt
							
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
										echo -n "$TIME_STAMP" >> $DATE\/$COURSE_ID/discussion_ids.txt
										echo >> $DATE\/$COURSE_ID/discussion_ids.txt
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
	done < "$DATE/$COURSE_ID/discussion_topics.json"

done < $DATE/course_ids.txt


#THIS PART RETRIVE ALL QUIZES IN EACH COURSE
#THEN JSON FILE WITH ALL QUIZES IS PARCED TO GET ALL QUIZES IDS (SAME AS COURSES IDS)

#USED API QUERIES:
#/api/v1/courses/<course_id>/quizzes


COURSE_ID=""
while read -r COURSE_ID; do
	
	curl -H "Authorization: Bearer $ACCESS_TOKEN" "$DOMAIN/courses/$COURSE_ID/quizzes" > $DATE\/$COURSE_ID/quizzes.json

	echo -n "" > $DATE\/$COURSE_ID/quizzes_ids.txt
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
								echo -n "$line" >> $DATE\/$COURSE_ID/quizzes_ids.txt
								read -n1 line
							done
							echo >> $DATE\/$COURSE_ID/quizzes_ids.txt
							
						fi
					fi
					prevprevprev=$prevprev
					prevprev=$prev
					prev=$line
				done
	done < "$DATE/$COURSE_ID/quizzes.json"

done < $DATE/course_ids.txt



#FOR EACH DISCUSSION WITHIN EACH COURSE
#RETRIVE CONTENT AS A JSON FILE

#USED API QUERIES:
#/api/v1/<course id>/discussion_topics/<discussion_id>/view
#/api/v1/<course id>/discussion_topics/<discussion_id>/entries


COURSE_ID=""
while read -r COURSE_ID; do
	mkdir $DATE\/$COURSE_ID/discussions
	
	while read -r DISCUSSION_ID; do
		read -r LAST_REPLY

	mkdir $DATE\/$COURSE_ID/discussions/$DISCUSSION_ID


	curl -H "Authorization: Bearer $ACCESS_TOKEN" "$DOMAIN/courses/$COURSE_ID/discussion_topics/$DISCUSSION_ID/view" > $DATE\/$COURSE_ID/discussions/$DISCUSSION_ID/view.json
	curl -H "Authorization: Bearer $ACCESS_TOKEN" "$DOMAIN/courses/$COURSE_ID/discussion_topics/$DISCUSSION_ID/entries" > $DATE\/$COURSE_ID/discussions/$DISCUSSION_ID/entries.json

		while IFS='' read -n1 line || [[ -n "$line" ]]; do
			if [ "$line" = "v" ]
			then
				read -n3 line
				if [ "$line" = "iew" ]
				then
					
					echo -n "" > $DATE\/$COURSE_ID/discussions/$DISCUSSION_ID/replies_ids.txt
					while read -n1 line; do
						if [ "$line" = "i" ] && [ "$prevprev" = "{" ]
							then
							read -n3 line
							if [ "$line" = "d\":" ]
							then
								re="^[0-9]+$"
								read -n1 line
								while [[ $line =~ $re ]]; do
									echo -n "$line" >> $DATE/$COURSE_ID\/discussions/$DISCUSSION_ID/replies_ids.txt
									read -n1 line
								done
								echo >> $DATE\/$COURSE_ID/discussions/$DISCUSSION_ID/replies_ids.txt
							fi
						fi
						prevprev=$prev
						prev=$line
					done
					
				fi
			fi
		done < "$DATE/$COURSE_ID/discussions/$DISCUSSION_ID/view.json"
	
	done < "$DATE/$COURSE_ID/discussion_ids.txt"

done < $DATE/course_ids.txt



#FOR EACH QUIZ WITHIN EACH COURSE
#RETRIVE STATISTICS AS A JSON FILE

#USED API QUERIES:
#/api/v1/courses/<course_id>/quizzes/<quiz_id>/submissions
#/api/v1/courses/<course_id>/quizzes/>quiz_id>/statistics
#/api/v1/courses/<course_id>/quizzes/<quiz_id>/reports



COURSE_ID=""
while read -r COURSE_ID; do
	mkdir $DATE\/$COURSE_ID/quizzes
	
	while read -r QUIZZ_ID; do

		mkdir $DATE\/$COURSE_ID/quizzes/$QUIZZ_ID


		curl -H "Authorization: Bearer $ACCESS_TOKEN" "$DOMAIN/courses/$COURSE_ID/quizzes/$QUIZZ_ID/submissions" > $DATE\/$COURSE_ID/quizzes/$QUIZZ_ID/submissions.json
		curl -H "Authorization: Bearer $ACCESS_TOKEN" "$DOMAIN/courses/$COURSE_ID/quizzes/$QUIZZ_ID/statistics" > $DATE\/$COURSE_ID/quizzes/$QUIZZ_ID/statistics.json
		curl -H "Authorization: Bearer $ACCESS_TOKEN" "$DOMAIN/courses/$COURSE_ID/quizzes/$QUIZZ_ID/reports" > $DATE\/$COURSE_ID/quizzes/$QUIZZ_ID/reports.json
	
	done < "$DATE/$COURSE_ID/quizzes_ids.txt"

done < $DATE/course_ids.txt


#THIS ART IS RESPONSIBLE FOR GETTING GROUPS WITHIN COURSES
#AND CREATING GROUPS_IDS.TXT
#API QUERIES
#api/v1/courses/<course_id/groups

COURSE_ID=""
while read -r COURSE_ID; do
	
	curl -H "Authorization: Bearer $ACCESS_TOKEN" "$DOMAIN/courses/$COURSE_ID/groups" > $DATE\/$COURSE_ID/groups.json

	echo -n "" > $DATE\/$COURSE_ID/groups_ids.txt
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
								echo -n "$line" >> $DATE\/$COURSE_ID/groups_ids.txt
								read -n1 line
							done
							echo >> $DATE\/$COURSE_ID/groups_ids.txt
							
						fi
					fi
					prevprevprev=$prevprev
					prevprev=$prev
					prev=$line
				done
	done < "$DATE/$COURSE_ID/groups.json"

done < $DATE/course_ids.txt


#THIS PART IS RESPONSBLE FOR GETTING GROUPS DISCUSSION

#API QUERIES
#api/v1/groups/<group_id>/discussion_topics

COURSE_ID=""
while read -r COURSE_ID; do
	mkdir $DATE\/$COURSE_ID/groups
	
	while read -r GROUP_ID; do
	
		mkdir $DATE\/$COURSE_ID\/groups/$GROUP_ID
	
		curl -H "Authorization: Bearer $ACCESS_TOKEN" "$DOMAIN/groups/$GROUP_ID/discussion_topics" > $DATE\/$COURSE_ID\/groups/$GROUP_ID/discussion_topics.json

		echo -n "" > $DATE\/$COURSE_ID\/groups/$GROUP_ID/discussion_ids.txt
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
									echo -n "$line" >> $DATE\/$COURSE_ID\/groups/$GROUP_ID/discussion_ids.txt
									read -n1 line
								done
								echo >> $DATE\/$COURSE_ID/groups/$GROUP_ID/discussion_ids.txt
								
							fi
						fi
						prevprevprev=$prevprev
						prevprev=$prev
						prev=$line
					done
		done < "$DATE/$COURSE_ID/groups/$GROUP_ID/discussion_topics.json"
		
	done < "$DATE/$COURSE_ID/groups_ids.txt"

done < $DATE/course_ids.txt


#THIS PART RETRIVES DATA FOR EACH DISCUSSION WITHIN A GROUPS

#QUERIES
#/api/v1/api/v1/groups/<group_id>/discussion_topics/<discussion_id>/view
#/api/v1/api/v1/groups/<group_id>/discussion_topics/<discussion_id>/entries


COURSE_ID=""
while read -r COURSE_ID; do
	while read -r GROUP_ID; do
		mkdir $DATE\/$COURSE_ID\/groups/$GROUP_ID/discussions
		
		while read -r DISCUSSION_ID; do
			read -r LAST_REPLY

			mkdir $DATE\/$COURSE_ID\/groups/$GROUP_ID/discussions/$DISCUSSION_ID


			curl -H "Authorization: Bearer $ACCESS_TOKEN" "$DOMAIN/groups/$GROUP_ID/discussion_topics/$DISCUSSION_ID/view" > $DATE\/$COURSE_ID\/groups/$GROUP_ID/discussions/$DISCUSSION_ID/view.json
			curl -H "Authorization: Bearer $ACCESS_TOKEN" "$DOMAIN/groups/$GROUP_ID/discussion_topics/$DISCUSSION_ID/entries" > $DATE\/$COURSE_ID\/groups/$GROUP_ID/discussions/$DISCUSSION_ID/entries.json

			while IFS='' read -n1 line || [[ -n "$line" ]]; do
				if [ "$line" = "v" ]
				then
					read -n3 line
					if [ "$line" = "iew" ]
					then
						
						echo -n "" > $DATE\/$COURSE_ID\/groups/$GROUP_ID/discussions/$DISCUSSION_ID/replies_ids.txt
						while read -n1 line; do
							if [ "$line" = "i" ] && [ "$prevprev" = "{" ]
								then
								read -n3 line
								if [ "$line" = "d\":" ]
								then
									re="^[0-9]+$"
									read -n1 line
									while [[ $line =~ $re ]]; do
										echo -n "$line" >> $DATE\/$COURSE_ID\/groups/$GROUP_ID/discussions/$DISCUSSION_ID/replies_ids.txt
										read -n1 line
									done
									echo >> $DATE\/$COURSE_ID\/groups/$GROUP_ID/discussions/$DISCUSSION_ID/replies_ids.txt
								fi
							fi
							prevprev=$prev
							prev=$line
						done
						
					fi
				fi
			done < "$DATE/$COURSE_ID/groups/$GROUP_ID/discussions/$DISCUSSION_ID/view.json"
		
		done < "$DATE/$COURSE_ID/groups/$GROUP_ID/discussion_ids.txt"
		
	done < "$DATE/$COURSE_ID/groups_ids.txt"

done < $DATE/course_ids.txt

