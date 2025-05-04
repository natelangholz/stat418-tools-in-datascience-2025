#!/bin/bash

# Homework 1

# Answer the following for each file.
# 1. List the top 10 web sites from which requests came (non-404 status).
# 2. What percentage of host requests came from IP vs hostname?
# 3. List the top 10 requests (non-404 status).
# 4.List the most frequent request types?
# 5. How many 404 errors were reported in the log?
# 6. What is the most frequent response code and what percentage of reponses did this account for?
# 7. What time of day is the site active? When is it quiet?
# 8. What is the biggest overall response (in bytes) and what is the  average?
# 9.There was a hurricane during August where there was no data collected. Identify the times and dates when data was not collected for August. How long was the outage?
# 10. Which date saw the most activity overall? 
# 11. Excluding the outage dates which date saw the least amount of activity?

#the following fetch both NASA log files from the corresponding urls and write. Write them to your l$directory and create a NEW .sh file that can be run on files named:
# NASA_Jul95.log
# NASA_Aug95.log

# [DOWNLOADING FILES - UNCOMMENT TO DOWNLOAD]
# Uncomment the curl lines if NASA_Jul95.log and NASA_Aug95.log are not in the local directory

#curl -s https://atlas.cs.brown.edu/data/web-logs/NASA_Jul95.log > NASA_Jul95.log
#if [ -f NASA_Jul95.log ]; then
        #echo "Downloaded NASA_Jul95.log"
#fi
  
#curl -s https://atlas.cs.brown.edu/data/web-logs/NASA_Aug95.log > NASA_Aug95.log
#if [ -f NASA_Aug95.log ]; then
        #echo "Downloaded NASA_Aug95.log"
#fi

echo -e "\n========== CHECKING DATA FIELDS==========\n"

echo -e "\nHead of NASA_Jul95.log:"
awk '{print $0}' NASA_Jul95.log | head -n 1
awk '{for(i = 1; i <= NF; i ++) print "Field $" i ": " $i; exit}' NASA_Jul95.log


echo -e "\nHead of NASA_Aug95.log:"
awk '{print $0}' NASA_Aug95.log | head -n 1
awk '{for(i = 1;i <= NF; i ++) print "Field $" i ": " $i; exit}' NASA_Aug95.log
echo


# ========== NUMBER 1 ==========
#1. filter for non-404 status (field 9)
#2. extract website (filed 1)
#3. sort list of websites
#4. count unique websites/ip
#5. sort by frequency
#6. display top 10'  

echo -e "\n========== NUMBER 1 ==========\n"

# PART A: NASA_Jul95.log
echo -e "[PART A: NASA_Jul95.log]\n"

echo "Top 10 websites from which requests came (non-404 status) for NASA_Jul95.log:"
awk '$9 != "404" {print $1}' NASA_Jul95.log | sort | uniq -c | sort -nr | head -n 10
echo

# PART B: NASA_Aug95.log
echo -e "[PART B: NASA_Aug95.log]\n"

echo "Top 10 websites from which requests came (non-404 status) for NASA_Aug95.log:"
awk '$9 != "404" {print $1}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -n 10
echo


# ========== NUMBER 2 ==========
#1. calculate total number of IP and hostname (Field 1) --> store as shell variable
#2. if $1 contains any letters (hostname) count ++ --> store as shell variable
#3. if $1 does not contain any letters count ++ --> store as shell variable
#4. pass shell variables into awk variables in order to calculate the percentage 


echo -e "\n========== NUMBER 2 ==========\n"

# PART A: NASA_Jul95.log
echo -e "[PART A: NASA_Jul95.log]\n"

total_host_requests=$(awk '$1 {count++} END {print count}' NASA_Jul95.log)
echo -e "Total number of rows in Field 1 (host requests): $total_host_requests"

requests_hostnames=$(awk '$1 ~ /[a-zA-Z]/ {count++} END {print count}' NASA_Jul95.log)
echo -e "Number of host requests that came from hostnames: $requests_hostnames"

requests_IPs=$(awk '$1 !~ /[a-zA-Z]/ {count++} END {print count}' NASA_Jul95.log)
echo -e "Number of host requests that came from IPs: $requests_IPs\n"

hostnames_percentage=$(awk -v requests_hostnames=$requests_hostnames -v total_host_requests=$total_host_requests \
	'BEGIN {print (requests_hostnames/total_host_requests) * 100}')
rounded_hostnames_percentage=$(printf "%.2f" $hostnames_percentage)
echo -e "Percentage of host requests that came from hostnames: $rounded_hostnames_percentage%"

IPs_percentage=$(awk -v requests_IPs=$requests_IPs -v total_host_requests=$total_host_requests \
	'BEGIN {print (requests_IPs/total_host_requests) * 100}')
rounded_IPs_percentage=$(printf "%.2f" $IPs_percentage)
echo -e "Percentage of host requests that came from IPs: $rounded_IPs_percentage%\n"

# PART B: NASA_Aug95.log
echo -e "[PART B: NASA_Aug95.log]\n"

total_host_requests_aug=$(awk '$1 {count++} END {print count}' NASA_Aug95.log)
echo -e "Total number of rows in Field 1 (host requests): $total_host_requests_aug"

requests_hostnames_aug=$(awk '$1 ~ /[a-zA-Z]/ {count++} END {print count}' NASA_Aug95.log)
echo -e "Number of host requests that came from hostnames: $requests_hostnames_aug"

requests_IPs_aug=$(awk '$1 !~ /[a-zA-Z]/ {count++} END {print count}' NASA_Aug95.log)
echo -e "Number of host requests that came from IPs: $requests_IPs_aug\n"

hostnames_percentage_aug=$(awk -v requests_hostnames_aug=$requests_hostnames_aug -v total_host_requests_aug=$total_host_requests_aug \
	'BEGIN {print (requests_hostnames_aug/total_host_requests_aug) * 100}')
rounded_hostnames_percentage_aug=$(printf "%.2f" $hostnames_percentage_aug)
echo -e "Percentage of host requests that came from hostnames: $rounded_hostnames_percentage_aug%"

IPs_percentage_aug=$(awk -v requests_IPs_aug=$requests_IPs_aug -v total_host_requests_aug=$total_host_requests_aug \
	'BEGIN {print (requests_IPs_aug/total_host_requests_aug) * 100}')
rounded_IPs_percentage_aug=$(printf "%.2f" $IPs_percentage_aug)
echo -e "Percentage of host requests that came from IPs: $rounded_IPs_percentage_aug%\n"


# ========== NUMBER 3 ==========

echo -e "\n========== NUMBER 3 ==========\n"

# PART A: NASA_Jul95.log
echo -e "[PART A: NASA_Jul95.log]\n"

echo "Top 10 requests/url-paths (non-404 status) for NASA_Jul95.log:"
export LC_ALL=C
# overrides sort: illegal byte sequence error

awk '$9 != "404" {print $7}' NASA_Jul95.log | sort | uniq -c | sort -nr | head -n 10
echo

# PART B: NASA_Aug95.log
echo -e "[PART B: NASA_Aug95.log]\n"

echo "Top 10 requests/url-paths (non-404 status) for NASA_Aug95.log:"
export LC_ALL=C
awk '$9 != "404" {print $7}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -n 10
echo


# ========== NUMBER 4 ==========
echo -e "\n========== NUMBER 4 ==========\n"

# PART A: NASA_Jul95.log
echo -e "[PART A: NASA_Jul95.log]\n"

echo "Most frequent request types for NASA_Jul95.log:"
export LC_ALL=C
awk '{gsub(/"/, "", $6); print $6}' NASA_Jul95.log | sort | uniq -c | sort -nr | head -n 3
echo

# PART B: NASA_Aug95.log
echo -e "[PART B: NASA_Aug95.log]\n"

echo "Most frequent request types for NASA_Aug95.log:"
export LC_ALL=C
awk '{gsub(/"/, "", $6); print $6}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -n 3
echo


# ========== NUMBER 5 ==========

echo -e "\n========== NUMBER 5 ==========\n"

# PART A: NASA_Jul95.log
echo -e "[PART A: NASA_Jul95.log]\n"

total_errors_jul=$(awk '$9 == "404" {count++} END {print count}' NASA_Jul95.log)
echo -e "Total 404 errors: $total_errors_jul\n"


# PART B: NASA_Aug95.log
echo -e "[PART B: NASA_Aug95.log]\n"

total_errors_aug=$(awk '$9 == "404" {count++} END {print count}' NASA_Aug95.log)
echo -e "Total 404 errors: $total_errors_aug\n"


# ========== NUMBER 6 ==========

echo -e "\n========== NUMBER 6 ==========\n"

# PART A: NASA_Jul95.log
echo -e "[PART A: NASA_Jul95.log]\n"

most_freq_code_full_jul=$(awk '{print $9}' NASA_Jul95.log | sort | uniq -c | sort -nr | head -n 1)

# using cut to split/extract count and response code 
most_freq_count_jul=$(echo "$most_freq_code_full_jul" | cut -d' ' -f1)
most_freq_code_jul=$(echo "$most_freq_code_full_jul" | cut -d' ' -f2)
echo -e "Most frequent response code: $most_freq_code_jul ($most_freq_count_jul times)"

total_resp_jul=$(awk '$1 {count++} END {print count}' NASA_Jul95.log)
echo -e "Total number of responses: $total_resp_jul\n"

most_freq_code_percentage_jul=$(awk -v most_freq_count_jul=$most_freq_count_jul -v total_resp_jul=$total_resp_jul \
	'BEGIN {print (most_freq_count_jul/total_resp_jul) * 100}')
rounded_most_freq_code_percentage_jul=$(printf "%.2f" $most_freq_code_percentage_jul)
echo -e "The most frequent response code is $most_freq_code_jul and accounted for $rounded_most_freq_code_percentage_jul% of responses.\n"


# PART B: NASA_Aug95.log
echo -e "[PART B: NASA_Aug95.log]\n"

most_freq_code_full_aug=$(awk '{print $9}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -n 1)

# using cut to split/extract count and response code 
most_freq_count_aug=$(echo "$most_freq_code_full_aug" | cut -d' ' -f1)
most_freq_code_aug=$(echo "$most_freq_code_full_aug" | cut -d' ' -f2)
echo -e "Most frequent response code: $most_freq_code_aug ($most_freq_count_aug times)"

total_resp_aug=$(awk '$1 {count++} END {print count}' NASA_Aug95.log)
echo -e "Total number of responses: $total_resp_aug\n"

most_freq_code_percentage_aug=$(awk -v most_freq_count_aug=$most_freq_count_aug -v total_resp_aug=$total_resp_aug \
	'BEGIN {print (most_freq_count_aug/total_resp_aug) * 100}')
rounded_most_freq_code_percentage_aug=$(printf "%.2f" $most_freq_code_percentage_aug)
echo -e "The most frequent response code is $most_freq_code_aug and accounted for $rounded_most_freq_code_percentage_aug% of responses.\n"


# ========== NUMBER 7 ==========

echo -e "\n========== NUMBER 7 ==========\n"

# PART A: NASA_Jul95.log
echo -e "[PART A: NASA_Jul95.log]\n"
export LC_ALL=C

# use cut to extract hour of the day from field 4 
time_count_jul=$(cut -d' ' -f4 NASA_Jul95.log | cut -d'[' -f2 | cut -d':' -f2 | grep -E '^[0-9]{2}$' | sort | uniq -c | sort -nr | head -n 1)

count_jul=$(echo "$time_count_jul" | cut -d' ' -f1)
time_jul=$(echo "$time_count_jul" | cut -d' ' -f2)

echo -e "Time of day the site is active (in 24 hour format): $time_jul (occurs $count_jul times)"

# use grep to only include two digit hours to avoid alyssa.p value 
time_count_quiet_jul=$(cut -d' ' -f4 NASA_Jul95.log | cut -d'[' -f2 | cut -d':' -f2 | grep -E '^[0-9]{2}$' | sort | uniq -c | sort -n | head -n  1)

count_quiet_jul=$(echo "$time_count_quiet_jul" | cut -d' ' -f1)
time_quiet_jul=$(echo "$time_count_quiet_jul" | cut -d' ' -f2)

echo -e "Time of day the site is quiet (in 24 hour format): $time_quiet_jul (occurs $count_quiet_jul times)\n"



# PART B: NASA_Aug95.log
echo -e "[PART B: NASA_Aug95.log]\n"
export LC_ALL=C

# use cut to extract hour of the day from field 4 
time_count_aug=$(cut -d' ' -f4 NASA_Aug95.log | cut -d'[' -f2 | cut -d':' -f2 | grep -E '^[0-9]{2}$' | sort | uniq -c | sort -nr | head -n 1)

count_aug=$(echo "$time_count_aug" | cut -d' ' -f1)
time_aug=$(echo "$time_count_aug" | cut -d' ' -f2)

echo -e "Time of day the site is active (in 24 hour format): $time_aug (occurs $count_aug times)"

# use grep to only include two digit hours (to avoid alyssa.p or other non two-digit hour values)
time_count_quiet_aug=$(cut -d' ' -f4 NASA_Aug95.log | cut -d'[' -f2 | cut -d':' -f2 | grep -E '^[0-9]{2}$' | sort | uniq -c | sort -n | head -n  1)

count_quiet_aug=$(echo "$time_count_quiet_aug" | cut -d' ' -f1)
time_quiet_aug=$(echo "$time_count_quiet_aug" | cut -d' ' -f2)

echo -e "Time of day the site is quiet (in 24 hour format): $time_quiet_aug (occurs $count_quiet_aug times)\n"


# ========== NUMBER 8 ==========

echo -e "\n========== NUMBER 8 ==========\n"

# PART A: NASA_Jul95.log
echo -e "[PART A: NASA_Jul95.log]\n"

biggest_response_jul=$(awk '{if($10 ~ /^[0-9]+$/) print $10}' NASA_Jul95.log | sort -nr | head -n 1)
echo -e "Biggest overall response (in bytes): $biggest_response_jul"

sum_resp_bytes_jul=$(awk '{if($10 ~ /^[0-9]+$/) sum += $10} END {print sum}' NASA_Jul95.log)
count_resp_bytes_jul=$(awk '{if($10 ~ /^[0-9]+$/) count++} END {print count}' NASA_Jul95.log)
average_resp_bytes_jul=$(awk -v sum_resp_bytes_jul=$sum_resp_bytes_jul -v count_resp_bytes_jul=$count_resp_bytes_jul \
	'BEGIN {print sum_resp_bytes_jul/count_resp_bytes_jul}')
echo -e "Average response (in bytes): $average_resp_bytes_jul\n"
#echo -e "	$sum_resp_bytes_jul/$count_resp_bytes_jul = $average_resp_bytes_jul\n"

# PART B: NASA_Aug95.log
echo -e "[PART B: NASA_Aug95.log]\n"

biggest_response_aug=$(awk '{if($10 ~ /^[0-9]+$/) print $10}' NASA_Aug95.log | sort -nr | head -n 1)
echo -e "Biggest overall response (in bytes): $biggest_response_aug"

sum_resp_bytes_aug=$(awk '{if($10 ~ /^[0-9]+$/) sum += $10} END {print sum}' NASA_Aug95.log)
count_resp_bytes_aug=$(awk '{if($10 ~ /^[0-9]+$/) count++} END {print count}' NASA_Aug95.log)
average_resp_bytes_aug=$(awk -v sum_resp_bytes_aug=$sum_resp_bytes_aug -v count_resp_bytes_aug=$count_resp_bytes_aug \
	'BEGIN {print sum_resp_bytes_aug/count_resp_bytes_aug}')
echo -e "Average response (in bytes): $average_resp_bytes_aug\n"
#echo -e "	$sum_resp_bytes_aug/$count_resp_bytes_aug = $average_resp_bytes_aug\n"


# ========== NUMBER 9 ==========
echo -e "\n========== NUMBER 9 ==========\n"

# Using NASA_Aug95.log
echo -e "[PART A: Using NASA_Aug95.log for Aug Dates]\n"

echo -e "All dates the site was accessed in August:"
awk '{print substr($4, 2, 2)}' NASA_Aug95.log | sort | uniq

echo -e "\n02/Aug/1995 is is the only date where the site was not accessed. To further investigate, we will print the last time logged on 01/Aug/1995 and earliest time logged for 03/Aug/1995.\n"

last_time_logged_aug1=$(grep "01/Aug/1995" NASA_Aug95.log | awk '{print substr($4, 14, 5)}' | tail -n 1)
echo -e "Last time logged on 01/Aug/1995 at $last_time_logged_aug1"

earliest_time_logged_aug3=$(grep "03/Aug/1995" NASA_Aug95.log | awk '{print substr($4, 14, 5)}' | head -n 1)
echo -e "Earliest time logged on 03/Aug/1995 at $earliest_time_logged_aug3\n"

echo -e "The data was not collected from 01/Aug/1995 $last_time_logged_aug1 to 03/Aug/1995 $earliest_time_logged_aug3. The duration of the outage was 37 hours and 44 minutes. "

# ========== NUMBER 10 ==========
echo -e "\n========== NUMBER 10 ==========\n"

# PART A: NASA_Jul95.log
echo -e "[PART A: NASA_Jul95.log]"

most_activity_jul=$(awk '{print substr($4, 2, 11)}' NASA_Jul95.log | sort | uniq -c | sort -nr | head -n 1)
count_activity_jul=$(echo "$most_activity_jul" | cut -d' ' -f1)
date_activity_jul=$(echo "$most_activity_jul" | cut -d' ' -f2)

echo -e "Date with the most activity: $date_activity_jul ($count_activity_jul times)\n"

# PART B: NASA_Aug95.log
echo -e "[PART B: NASA_Aug95.log]"

most_activity_aug=$(awk '{print substr($4, 2, 11)}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -n 1)
count_activity_aug=$(echo "$most_activity_aug" | cut -d' ' -f1)
date_activity_aug=$(echo "$most_activity_aug" | cut -d' ' -f2)

echo -e "Date with the most activity: $date_activity_aug ($count_activity_aug times)\n"

echo -e "The date with the most activity overall is $date_activity_jul which occurred $count_activity_jul times.\n"

# ========== NUMBER 11 ==========
echo -e "\n========== NUMBER 11 ==========\n"

# PART A: NASA_Jul95.log
echo -e "[PART A: NASA_Aug95.log]\n"

least_activity_aug=$(awk '{
	date = substr($4, 2, 11)
	if (date != "01/Aug/1995" && date != "02/Aug/1995" && date != "03/Aug/1995") print date
	}' NASA_Aug95.log | sort | uniq -c | sort -n | head -n 1)

count_least_activity_aug=$(echo "$least_activity_aug" | awk '{print $1}')
date_least_activity_aug=$(echo "$least_activity_aug" | awk '{print $2}')

echo -e "Outage dates: 01/Aug/1995, 02/Aug/1995, 03/Aug/1995"
echo -e "Date with the least activity (excluding outage dates): $date_least_activity_aug ($count_least_activity_aug times)"