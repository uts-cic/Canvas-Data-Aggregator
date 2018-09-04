#!/bin/bash



#READING CONFIG FILE
#FIRST STEP OF ANY SCRIPT
#INITIAL SETTINGS
ACCESS_TOKEN=""
DOMAIN=""
DATE=CANVAS

if( [ "$#" -ge 1 ] && [ "$1" = "-e" ] )
then
	DATE=$(date +%Y%m%d%H%M%S)
fi

while true; do
	read -r DOMAIN
	read -r ACCESS_TOKEN
	break
done < config.txt

DOMAIN+="/api/v1/"

src/get_courses.sh $ACCESS_TOKEN $DOMAIN $DATE

src/get_course_discussions/get_course_discussion_topics_1.sh $ACCESS_TOKEN $DOMAIN $DATE

src/get_discussion_details/get_discussion_1.sh $ACCESS_TOKEN $DOMAIN $DATE &

src/get_quizzes/get_course_1.sh $ACCESS_TOKEN $DOMAIN $DATE &
 
src/get_groups/get_course_1.sh $ACCESS_TOKEN $DOMAIN $DATE &

wait

src/get_quizz_details/get_quizz_1.sh $ACCESS_TOKEN $DOMAIN $DATE

src/get_group_discussions/get_group_1.sh $ACCESS_TOKEN $DOMAIN $DATE

src/get_group_discussion_details/get_group_discussion_1.sh $ACCESS_TOKEN $DOMAIN $DATE

