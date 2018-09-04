# Canvas-Data-Aggregator
Shell script for getting data from Canvas using Access Token.

### How to use
```
1. Download script
2. Set up config
3. Launch script. Script has two modes
     3.1 ./aggregator.sh      dowloads relusts in folder CANVAS
     3.2 ./aggregator.sh -e   experimental key. Create individual Timestamp folder with data
```

### Data Structure
Script uses provided Canvas Domain Name and Access Token to retrive data from Canvas. This data includes:

     1 Courses     
       1.1 Enrollments
       1.2 Recent Students
       1.3 Discussion Topics
          1.3.1 View
          1.3.2 Entries          
       1.4 Groups
          1.4.1 Discussion Topics
               1.4.1.1 View
               1.4.1.2 Entries
       1.5 Quizzes
          1.5.1 Submissions
          1.5.2 Statistics
          1.5.3 Reports
   
All files are downloaded as .json. In addition, script parses some of .json files to get course ids and discussion ids to simple .txt files

### File structure
After downloading files will be presented as following hierarchy:

     1 CANVAS or Timestamp (allows to divide samples and track changes)
          1.1 Courses.json  
          1.2 Courses_ids.txt  
          1.3 Folders for each course. Folder name is course ID  
               1.3.1 discussion_topics.json    
               1.3.2 enrollments.json    
               1.3.3 recent_students.json    
               1.3.4 discussion_ids.txt    
               1.3.5 disscussions
                    1.3.5.1 Folder for each discussion within course. Folder name is dicsussion ID   
                         1.3.5.1.1 entries.json      
                         1.3.5.2.2 view.json      
                         1.3.5.3.3 replies_ids.txt
               1.3.6 quizzes.json
               1.3.7 quizzes_ids.txt   
               1.3.8 quizzes
                    1.3.8.1 Folder for each quizz. Folder name is quizz ID
                         1.3.8.1 statistics.json
                         1.3.8.1 reports.json
                         1.3.8.1 submissions.json
               1.3.9 groups.json
               1.3.10 group_ids.txt
               1.3.11 groups
                    1.3.11.1 Folder for each group. Folder name is group ID
                         1.3.11.1.1 discussion_topics.json
                         1.3.11.1.2 discussion_ids.txt
                         1.3.11.1.3 discussions
                              1.3.11.1.3.1 entries.json  
                              1.3.11.1.3.2 view.json  
                              1.3.11.1.3.3 replies_ids.txt



### Script Structure

Script consist of two files:
```
1. config.txt
2. aggregator.sh
3. src
     3.1 get_course.sh
     3.2 get_course_discussions
     3.3 get_discussion_details
     3.4 get_quizzes
     3.5 get_quizz_details
     3.6 get_groups
     3.7 get_group_discussions
     3.8 get_group_discussion_details
```

Config includes:
```
     1. Domain Name
     2. Access Token
 ```

Follow instructions in config file to set your own parameters
