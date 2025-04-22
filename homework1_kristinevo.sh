#!/bin/bash

# Homework 1: Parse the web server access logs from the two files located at https://atlas.cs.brown.edu/data/web-logs/NASA_Jul95.log and https://atlas.cs.brown.edu/data/web-logs/NASA_Aug95.log. You may complete this assignment with one script using a combination of Awk/cut commands. Write both files to your local hw1 directory and create a NEW .sh file that can be run on files named:
# NASA_Jul95.log
# NASA_Aug95.log

# Due date is Tuesday April 22, 2025 at 6pm. Please submit your script to the course github repo as a pull request to the homework submission folder here and the branch hw1-submissions.

# Answer the following questions with your script and have any words to support your commands written as comments.


#########################################
# QUESTION 1 THROUGH 8 FOR JULY FILE
#########################################
FILE="NASA_Jul95.log"
echo "==========================================="
echo "Analyzing July file: $FILE"
echo "==========================================="

# 1. List the top 10 websites from which requests came (non-404 status).
echo -e "\n1. Top 10 websites where requests came from (non-404 status):"
awk '$9 != 404 {print $1}' "$FILE" | sort | uniq -c | sort -rn | head -10
#$9 refers to the 9th field of the log file and we want to filter for any non-404 status websites
#sort is used to groups together hostnames that are the same
#uniq -c provides the count freq
#sort -rn sorts the count but in reverse order
#head -10 just shows top 10

# 2. What percentage of host requests came from IP vs hostname?
echo -e "\n2. What percentage of host requests came from IP vs hostname?:"
total=$(cut -d' ' -f1 "$FILE" | wc -l)
ips=$(cut -d' ' -f1 "$FILE" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)
hosts=$((total - ips))
ip_percent=$(awk "BEGIN {printf \"%.2f\", ($ips/$total)*100}")
host_percent=$(awk "BEGIN {printf \"%.2f\", ($hosts/$total)*100}")
echo "Hostnames: $host_percent% | IPs: $ip_percent%"
#cut -d' ' -f1 will extract the first value from each line of the log, delimiter is a space
#wc -l provides the the total number of lines in the log
#grep -E ing reg ex to recognize the ip address pattern

# 3. List the top 10 requests (non-404 status).
echo -e "\n3. List the top 10 requests (non-404 status):"
awk '$9 != 404 {for(i=6;i<=8;++i) printf "%s ", $i; print ""}' "$FILE" | tr -d '"' | sort | uniq -c | sort -rn | head -10
#Again, we start by filtering out lines of 404 status
#Requests are in fields 6, 7, and 8
#tr -d '"' removes the quotes from the request
#similar to problem 1 we sort to group the request together
#unique -c gives us the count frequency
#sort -rn sorts in reverse order

# 4. List the most frequent request types
echo -e "\n4. List the most frequent request types:"
awk '{gsub(/"/,""); print $6}' "$FILE" | sort | uniq -c | sort -rn
#gsub(/"/,"") removes the quotes
#similar to problem 1 we sort to group the request together
#unique -c gives us the count frequency
#sort -rn sorts in reverse order

# 5. 404 error count
echo -e "\n5. Number of 404 errors:"
awk '$9 == 404' "$FILE" | wc -l
#now we want to filter for 404 errors
#wc -l is counts the total number fo 404 lines

# 6. What is the most frequent response code and what percentage of reponses did this account for?
echo -e "\n6. What is the most frequent response code and what percentage of reponses did this account for?:"
awk '{print $9}' "$FILE" | grep -E '^[0-9]+$' | sort | uniq -c | sort -rn | head -1 | while read count code; do
  total=$(awk '{print $9}' "$FILE" | grep -E '^[0-9]+$' | wc -l)
  percent=$(awk "BEGIN {printf \"%.2f\", ($count/$total)*100}")
  echo "$code ($percent%)"
done
#grep -E '^[0-9]+$' remove missing or fields that do not match the response code structure

# 7. What time of day is the site active? When is it quiet?
echo "7a. Most active hour:"
LC_ALL=C awk '{h=substr($4,14,2); if(h ~ /^[0-9][0-9]$/) print h}' NASA_Jul95.log | sort | uniq -c | sort -rn | head -1

echo "7b. Least active hour:"
LC_ALL=C awk '{h=substr($4,14,2); if(h ~ /^[0-9][0-9]$/) print h}' NASA_Jul95.log | sort | uniq -c | sort -n | head -1

# 8. What is the biggest overall response (in bytes) and what is the average?
echo -e "\n8. What is the biggest overall response (in bytes) and what is the average?:"
awk '$10 ~ /^[0-9]+$/ {sum+=$10; if ($10 > max) max = $10} END {printf "Max: %d, Average: %.2f\n", max, sum/NR}' "$FILE"
#Had to look up how to do this question

#########################################
# QUESTION 1 THROUGH 8 FOR AUGUST FILE
#########################################
FILE="NASA_Aug95.log"
echo -e "\n\n==========================================="
echo "Analyzing August file: $FILE"
echo "==========================================="

# 1. List the top 10 websites from which requests came (non-404 status).
echo -e "\n1. Top 10 websites where requests came from (non-404 status):"
awk '$9 != 404 {print $1}' "$FILE" | sort | uniq -c | sort -rn | head -10
#$9 refers to the 9th field of the log file and we want to filter for any non-404 status websites
#sort is used to groups together hostnames that are the same
#uniq -c provides the count freq
#sort -rn sorts the count but in reverse order
#head -10 just shows top 10

# 2. What percentage of host requests came from IP vs hostname?
echo -e "\n2. What percentage of host requests came from IP vs hostname?:"
total=$(cut -d' ' -f1 "$FILE" | wc -l)
ips=$(cut -d' ' -f1 "$FILE" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)
hosts=$((total - ips))
ip_percent=$(awk "BEGIN {printf \"%.2f\", ($ips/$total)*100}")
host_percent=$(awk "BEGIN {printf \"%.2f\", ($hosts/$total)*100}")
echo "Hostnames: $host_percent% | IPs: $ip_percent%"
#cut -d' ' -f1 will extract the first value from each line of the log, delimiter is a space
#wc -l provides the the total number of lines in the log
#grep -E ing reg ex to recognize the ip address pattern

# 3. List the top 10 requests (non-404 status).
echo -e "\n3. List the top 10 requests (non-404 status):"
awk '$9 != 404 {for(i=6;i<=8;++i) printf "%s ", $i; print ""}' "$FILE" | tr -d '"' | sort | uniq -c | sort -rn | head -10
#Again, we start by filtering out lines of 404 status
#Requests are in fields 6, 7, and 8
#tr -d '"' removes the quotes from the request
#similar to problem 1 we sort to group the request together
#unique -c gives us the count frequency
#sort -rn sorts in reverse order

# 4. List the most frequent request types
echo -e "\n4. List the most frequent request types:"
awk '{gsub(/"/,""); print $6}' "$FILE" | sort | uniq -c | sort -rn
#gsub(/"/,"") removes the quotes
#similar to problem 1 we sort to group the request together
#unique -c gives us the count frequency
#sort -rn sorts in reverse order

# 5. 404 error count
echo -e "\n5. Number of 404 errors:"
awk '$9 == 404' "$FILE" | wc -l
#now we want to filter for 404 errors
#wc -l is counts the total number fo 404 lines

# 6. What is the most frequent response code and what percentage of reponses did this account for?
echo -e "\n6. What is the most frequent response code and what percentage of reponses did this account for?:"
awk '{print $9}' "$FILE" | grep -E '^[0-9]+$' | sort | uniq -c | sort -rn | head -1 | while read count code; do
  total=$(awk '{print $9}' "$FILE" | grep -E '^[0-9]+$' | wc -l)
  percent=$(awk "BEGIN {printf \"%.2f\", ($count/$total)*100}")
  echo "$code ($percent%)"
done
#grep -E '^[0-9]+$' remove missing or fields that do not match the response code structure

# 7. What time of day is the site active? When is it quiet?
echo "7. What time of day is the site active? When is it quiet?"
echo "7a. Most active hour:"
LC_ALL=C awk '{h=substr($4,14,2); if(h ~ /^[0-9][0-9]$/) print h}' NASA_Jul95.log | sort | uniq -c | sort -rn | head -1

echo "7b. Least active hour:"
LC_ALL=C awk '{h=substr($4,14,2); if(h ~ /^[0-9][0-9]$/) print h}' NASA_Jul95.log | sort | uniq -c | sort -n | head -1

# 8. What is the biggest overall response (in bytes) and what is the average?
echo -e "\n8. What is the biggest overall response (in bytes) and what is the average?:"
awk '$10 ~ /^[0-9]+$/ {sum+=$10; if ($10 > max) max = $10} END {printf "Max: %d, Average: %.2f\n", max, sum/NR}' "$FILE"
#Had to look up how to do this question

#########################################
# QUESTION 9 THROUGH 11 FOR AUGUST FILE
#########################################

echo -e "9. Identify the times and dates when data was not collected for August. How long was the outage?"
# I had to look up how to do this because I kept getting errors

LC_ALL=C awk '
{
  raw = substr($4, 2)
  split(raw, datetime, ":")
  split(datetime[1], parts, "/")
  if (parts[2] == "Aug") {
    timestamp = parts[1] "/" parts[2] "/" parts[3] ":" datetime[2] ":" datetime[3] ":" datetime[4]
    cmd = "date -j -f \"%d/%b/%Y:%H:%M:%S\" \"" timestamp "\" +%s"
    cmd | getline current
    close(cmd)

    if (last && (current - last) > 3600) {
      printf "Outage Detected:\n"
      printf "  Last log before outage: %s\n", last_raw
      printf "  First log after outage: %s\n", timestamp
      printf "  Duration: %.2f hours (%.2f days)\n\n", (current - last)/3600, (current - last)/86400
      exit
    }

    last = current
    last_raw = timestamp
  }
}' NASA_Aug95.log

# 10. What is the biggest overall response (in bytes) and what is the average?
echo -e "10. Which date saw the most activity overall?"

LC_ALL=C cut -d'[' -f2 NASA_Aug95.log | cut -d: -f1 | grep 'Aug/1995' | sort | uniq -c | sort -rn | head -1
#Gives me error, but checked and apparently answer still correct

# 11. Excluding the outage dates which date saw the least amount of activity?
echo -e "11. Excluding the outage dates which date saw the least amount of activity?:"

LC_ALL=C cut -d'[' -f2 NASA_Aug95.log | cut -d: -f1 | grep 'Aug/1995' \
  | grep -vE '^01/Aug/1995|^02/Aug/1995|^03/Aug/1995' \
  | sort | uniq -c | sort -n | head -1
