#!/bin/bash

#FOR EACH DISCUSSION WITHIN EACH COURSE
#RETRIVE CONTENT AS A JSON FILE

#USED API QUERIES:
#/api/v1/<course id>/discussion_topics/<discussion_id>/view
#/api/v1/<course id>/discussion_topics/<discussion_id>/entries


curl -s -H "Authorization: Bearer $1" "$2/courses/$4/discussion_topics/$5/view?per_page=100" > $3\/$4/discussions/$5/view.json
curl -s -H "Authorization: Bearer $1" "$2/courses/$4/discussion_topics/$5/entries?per_page=100" > $3\/$4/discussions/$5/entries.json
while IFS='' read -n1 line || [[ -n "$line" ]]; do
	if [ "$line" = "v" ]
	then
		read -n3 line
		if [ "$line" = "iew" ]
		then
			
			echo -n "" > $3\/$4/discussions/$5/replies_ids.txt
			while read -n1 line; do
				if [ "$line" = "i" ] && [ "$prevprev" = "{" ]
					then
					read -n3 line
					if [ "$line" = "d\":" ]
					then
						re="^[0-9]+$"
						read -n1 line
						while [[ $line =~ $re ]]; do
							echo -n "$line" >> $3/$4\/discussions/$5/replies_ids.txt
							read -n1 line
						done
						echo >> $3\/$4/discussions/$5/replies_ids.txt
						fi
				fi
				prevprev=$prev
				prev=$line
			done
			
		fi
	fi
done < "$3/$4/discussions/$5/view.json"