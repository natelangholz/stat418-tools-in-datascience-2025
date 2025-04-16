# Homework 1

Parse the web server access logs from the two files located at https://atlas.cs.brown.edu/data/web-logs/NASA_Jul95.log and https://atlas.cs.brown.edu/data/web-logs/NASA_Aug95.log. You may complete this assignment with one script using a combination of Awk/cut commands. Write both files to your local hw1 directory and create a NEW .sh file that can be run on files named:
NASA_Jul95.log
NASA_Aug95.log

Due date is Tuesday April 22, 2025 at 6pm. Please submit your script to the course github repo as a pull request to the homework submission folder here and the branch hw1-submissions.

Answer the following questions with your script and have any words to support your commands written as comments.

Answer the following for each file.

1. List the top 10 web sites from which requests came (non-404 status).
2. What percentage of host requests came from IP vs hostname?
3. List the top 10 requests (non-404 status).
4. List the most frequent request types? 
5. How many 404 errors were reported in the log? 
6. What is the most frequent response code and what percentage of reponses did this account for? 
7. What time of day is the site active? When is it quiet?
8. What is the biggest overall response (in bytes) and what is the average?

9.There was a hurricane during August where there was no data collected. Identify the times and dates when data was not collected for August. How long was the outage?
10. Which date saw the most activity overall?
11. Excluding the outage dates which date saw the least amount of activity?
