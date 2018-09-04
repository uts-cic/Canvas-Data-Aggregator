#!/bin/bash

#GETS AND PARSES COURSES

# $1 - access token
# $2 - domain
# $3 - timestamp

#RUNNING CURL 
#WE NEED QUERY AS FOLLOWING EXAMPLE
#WE NEED TO RUN SIMPLE QUERY curl -H "Authorization: Bearer <ACCESS_TOKEN>" "<DOMAIN> + <CANVAS_API_REQUEST>" > <OUTPUT_FILE_NAME.JSON>
#EXAMPLE (NOT REAL TOKEN)
#curl -H "Authorization: Bearer 45745745~njshfg767BHFgui" "https://uts-dev.instructure.com/api/v1/courses>" > courses.json
#CURL WILL USE ACCESS_TOKEN AND DOMAIN VARIABLES
#THE OUTCOME WILL BE STORES IN A .json FILE

#USED API QUERIES:
#/api/v1/courses

mkdir -p $3
echo
echo "GETTING COURSES..."
curl -s -H "Authorization: Bearer $1" "$2/courses?per_page=100" > $3/courses.json
echo "COURSES ARE DOWNLOADED"
echo

#AFTER WE HAVE JSON FILE FROM CANVAS WE NEED ALL AVAILABLE COURSE IDS
#PARSE COURSE.JSON FOR ALL COURSES IDS

while IFS='' read -n1 line || [[ -n "$line" ]]; do
	echo -n "" > $3/course_ids.txt
	while read -n1 line; do
		if [ "$line" = "i" ] && [ "$prevprev" = "{" ]
			then
			read -n3 line
			if [ "$line" = "d\":" ]
			then
				re="^[0-9]+$"
				read -n1 line
				while [[ $line =~ $re ]]; do
					echo -n "$line" >> $3/course_ids.txt
					read -n1 line
				done
				echo >> $3/course_ids.txt
			fi
		fi
		prevprev=$prev
		prev=$line
	done
done < "$3/courses.json"