#!/bin/bash

# ================================
# Homework 1 - NASA Log Analysis 
# Mary Velasquez
# ================================

# Combine both log files
combined_logs="NASA_Jul95.log NASA_Aug95.log"

# Question 1: List the top 10 websites from which requests came (non-404 status)
echo "----- Question 1: Top 10 Websites (Non-404) for July + August -----"
awk '$9 != 404 {print $1}' $combined_logs | sort | uniq -c | sort -nr | head -10

# Question 2: What percentage of host requests came from IP vs hostname?
echo "----- Question 2: IP vs Hostname for July + August -----"
total=$(awk '{print $1}' $combined_logs | wc -l)
ip_count=$(awk '{print $1}' $combined_logs | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)
hostname_count=$((total - ip_count))
ip_pct=$(echo "scale=2; 100 * $ip_count / $total" | bc)
hostname_pct=$(echo "scale=2; 100 * $hostname_count / $total" | bc)
echo "IP: $ip_pct% | Hostname: $hostname_pct%"

# Question 3: List the top 10 requests (non-404 status)
echo "----- Question 3: Top 10 Requests (Non-404) for July + August -----"

awk '$9 != 404 {print $7}' $combined_logs \
  | LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr | head -10


# Question 4: List the most frequent request types
echo "----- Question 4: Most Frequent Request Types for July + August -----"

awk '{print $6}' $combined_logs \
  | tr -d '"' 2>/dev/null \
  | sort | uniq -c | sort -nr

  # Question 5: How many 404 errors were reported in the log?
echo "----- Question 5: Number of 404 Errors in July + August -----"

awk '$9 == 404' $combined_logs | wc -l

# Question 6: What is the most frequent response code and what percentage of reponses did this account for?
echo "----- Question 6: Most Frequent Response Code and Percentange for July + August -----"

awk '{print $9}' $combined_logs \
  | sort | uniq -c | sort -nr > response_counts.txt

# Extract just the code and the count
most_code=$(head -1 response_counts.txt | awk '{print $2}')
code_count=$(head -1 response_counts.txt | awk '{print $1}')
total_count=$(cat $combined_logs | wc -l)

percent=$(echo "scale=2; 100 * $code_count / $total_count" | bc)

echo "Most Frequent Response Code: $most_code"
echo "Accounts For: $percent% of all responses"

# Question 7: What time of day is the site active? When is it quiet?
echo "----- Question 7: Site Activity by Hour for July + August -----"

awk '{ if ($4 ~ /\[[0-9]{2}\/[A-Za-z]+\/[0-9]{4}:[0-9]{2}:/) {
  split($4, time, ":"); hour = substr(time[2], 1, 2); print hour }
}' $combined_logs \
  | sort | uniq -c | sort -nr > hourly_activity.txt

echo "Top 5 Busiest Hours:"
head -5 hourly_activity.txt

echo "Top 5 Quietest Hours:"
tail -5 hourly_activity.txt

# Question 8: What is the biggest overall response (in bytes) and what is the average?
echo "----- Question 8: Max and Average Response Size for July + August -----"

awk '$10 != "-" {print $10}' $combined_logs > response_sizes.txt

max_size=$(sort -n response_sizes.txt | tail -1)

total=$(awk '{sum += $1} END {print sum}' response_sizes.txt)
count=$(wc -l < response_sizes.txt)
average=$(echo "scale=2; $total / $count" | bc)

echo "Max Response Size: $max_size bytes"
echo "Average Response Size: $average bytes"

# Question 9: There was a hurricane during August where there was no data collected.
# Identify the times and dates when data was not collected for August. How long was the outage? 
echo "----- Question 9: Hurricane Outage Dates in August -----"

awk '{print $4}' NASA_Aug95.log \
  | cut -d: -f1 \
  | tr -d '[' \
  | sort | uniq > august_dates.txt

for day in $(seq -w 01 31); do
  if ! grep -q "$day/Aug/1995" august_dates.txt; then
    echo "Missing Date(s): $day/Aug/1995"
  fi
done

# Question 10: Which date saw the most activity overall?
# Question 11: Excluding the outage dates which date saw the least amount of activity?
echo "----- Question 10 & 11: Most Active Date and Least Active Date (July + August) -----"

awk '{print $4}' $combined_logs \
  | cut -d: -f1 | tr -d '[' \
  | sort | uniq -c > date_counts.txt

sort -nr date_counts.txt | head -1 | awk '{print "Most Active Date:", $2, "- Requests:", $1}'

for i in $(seq -w 01 31); do echo "$i/Aug/1995"; done > all_august_days.txt

awk '{print $4}' NASA_Aug95.log \
  | cut -d: -f1 | tr -d '[' | sort | uniq > observed_august_days.txt

comm -23 all_august_days.txt observed_august_days.txt > outage_dates.txt

grep -vFf outage_dates.txt date_counts.txt > filtered_counts.txt

awk 'NF == 2' filtered_counts.txt | sort -n | head -1 | awk '{print "Least Active Date:", $2, "- Requests:", $1}'
