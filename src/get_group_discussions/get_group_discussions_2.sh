#!/bin/bash

#THIS PART IS RESPONSBLE FOR GETTING GROUPS DISCUSSION

#API QUERIES
#api/v1/groups/<group_id>/discussion_topics

curl -s -H "Authorization: Bearer $1" "$2/groups/$5/discussion_topics?per_page=100" > $3\/$4\/groups/$5/discussion_topics.json
echo -n "" > $3\/$4\/groups/$5/discussion_ids.txt
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
					echo -n "$line" >> $3\/$4\/groups/$5/discussion_ids.txt
					read -n1 line
				done
				echo >> $3\/$4/groups/$5/discussion_ids.txt
				
			fi
		fi
		prevprevprev=$prevprev
		prevprev=$prev
		prev=$line
	done
done < "$3/$4/groups/$5/discussion_topics.json"