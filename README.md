# Canvas-Data-Aggregator
Shell script for getting data from Canvas using Access Token.

Script uses provided Canvas Domain Name and Access Token to retrive data from Canvas. This data includes:
1. Courses
  1.1 Enrollments
  1.2 Recent Students
  1.3 Discussion Topics
    1.3.1 View
    1.3.2 Entries
   
All files are downloaded as .json. In addition, script parses some of .json files to get course ids and discussion ids to simple .txt files
After downloading files will be presented as following hierarchy:

1. Timestamp (allows to divide samples and track changes)
  1.1 Courses.json
  1.2 Courses_ids.txt
  1.3+ Folders for each course. Folder name is course ID
    1.3.1 discussion_topics.json
    1.3.2 enrollments.json
    1.3.3 recent_students.json
    1.3.4 discussion_ids.txt
    1.3.5+ Folders for each discussion within course. Folder name is dicsussion ID
      1.3.5.1 entries.json
      1.3.5.2 view.json
      1.3.5.3 replies_ids.txt





Script consist of two files:
1. config.txt
2. aggregator.sh

Config includes:
1. Domain Name
2. Access Token

Follow instructions in config file to set your own paramenters


