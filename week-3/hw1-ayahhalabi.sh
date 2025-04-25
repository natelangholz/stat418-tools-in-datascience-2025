#!/bin/bash

# 1. List the top 10 web sites from which requests came (non-404 status).


echo "Top 10 requesters (non-404) in NASA_Jul95.log:"
awk '$9 != 404 { print $1 }' NASA_Jul95.log | sort | uniq -c | sort -nr | head -10

echo "Top 10 requesters (non-404) in NASA_Aug95.log:"
awk '$9 != 404 { print $1 }' NASA_Aug95.log | sort | uniq -c | sort -nr | head -10


# 2. What percentage of host requests came from IP vs hostname?


ip_count=$(awk '{print $1}' NASA_Jul95.log | grep -E "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$" | wc -l)
total=$(awk '{print $1}' NASA_Jul95.log | wc -l)
hn_count=$((total - ip_count ))

ip_percent=$(awk "BEGIN { printf \"%.2f\", ($ip_count / $total) * 100 }")
hn_percent=$(awk "BEGIN { printf \"%.2f\", ($hn_count / $total) * 100 }")


echo "IP Requests: $ip_count / $total ($ip_percent%)"
echo "Hostnames Requests: $hn_count / $total ($hn_percent%)"

ip_count=$(awk '{print $1}' NASA_Aug95.log | grep -E "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$" | wc -l)
total=$(awk '{print $1}' NASA_Aug95.log | wc -l)
hn_count=$((total - ip_count ))

ip_percent=$(awk "BEGIN { printf \"%.2f\", ($ip_count / $total) * 100 }")
hn_percent=$(awk "BEGIN { printf \"%.2f\", ($hn_count / $total) * 100 }")


echo "IP Requests: $ip_count / $total ($ip_percent%)"
echo "Hostnames Requests: $hn_count / $total ($hn_percent%)"

# 3. List the top 10 requests (non-404 status).

echo "top 10 requests from July"
awk '$9 != 404 { print $6, $7, $8 }' NASA_Jul95.log | iconv -c -f utf-8 -t ascii | sort | uniq -c | sort -nr | head -10

echo "top 10 requests from Aug"

awk '$9 != 404 { print $6, $7, $8 }' NASA_Aug95.log | iconv -c -f utf-8 -t ascii | sort | uniq -c | sort -nr | head -10

# 4. List the most frequent request types? 

echo "Most frequent request types in July"
LC_CTYPE=C iconv -f UTF-8 -t ASCII//TRANSLIT//IGNORE NASA_Jul95.log | awk '{print $6}' | sort | uniq -c | sort -nr | head -1 


echo "Most frequent request types in Aug"
LC_CTYPE=C iconv -f UTF-8 -t ASCII//TRANSLIT//IGNORE NASA_Aug95.log | awk '{print $6}' | sort | uniq -c | sort -nr | head -1 

# 5. How many 404 errors were reported in the log? 

echo " 404 errors were reported in July"
awk '$9 == 404' NASA_Jul95.log | wc -l

echo " 404 errors were reported in August"
awk '$9 == 404' NASA_Aug95.log | wc -l

# 6. What is the most frequent response code and what percentage of reponses did this account for? 

# No spaces around the equal signs for variable assignment!
most_freq=$(awk '{print $9}' NASA_Jul95.log | sort | uniq -c | sort -nr | head -1)

# Extract the count and code from the top result
count=$(echo $most_freq | awk '{print $1}')
code=$(echo $most_freq | awk '{print $2}')

# Get the total number of responses
total=$(awk '{print $9}' NASA_Jul95.log | wc -l)

# Calculate the percentage
freq_percent=$(awk "BEGIN { printf \"%.2f\", ($count / $total) * 100 }")

# Output
echo "Most frequent response code for July : $code"
echo "Count: $count out of $total"
echo "Percentage: $freq_percent%"

# No spaces around the equal signs for variable assignment!
most_freq=$(awk '{print $9}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -1)

# Extract the count and code from the top result
count=$(echo $most_freq | awk '{print $1}')
code=$(echo $most_freq | awk '{print $2}')

# Get the total number of responses
total=$(awk '{print $9}' NASA_Aug95.log | wc -l)

# Calculate the percentage
freq_percent=$(awk "BEGIN { printf \"%.2f\", ($count / $total) * 100 }")

# Output
echo "Most frequent response code for August : $code"
echo "Count: $count out of $total"
echo "Percentage: $freq_percent%"


# 7. What time of day is the site active? When is it quiet?

echo "Most frequent hour in July"
awk -F: '{print substr($2, 1, 2)}' NASA_Jul95.log | sort | uniq -c | sort -nr | head -1 | awk '{print "Hour: " $2 ", Requests: " $1}'

echo "Least frequent hour in July"
awk -F: '{print substr($2, 1, 2)}' NASA_Jul95.log | sort | uniq -c | sort -n | head -1 | awk '{print "Hour: " $2 ", Requests: " $1}'

echo "Most frequent hour in Aug"
awk -F: '{print substr($2, 1, 2)}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -1 | awk '{print "Hour: " $2 ", Requests: " $1}'

echo "Least frequent hour in Aug"
awk -F: '{print substr($2, 1, 2)}' NASA_Aug95.log | sort | uniq -c | sort -n | head -1 | awk '{print "Hour: " $2 ", Requests: " $1}'


# 8. What is the biggest overall response (in bytes) and what is the average?

# Biggest response (in bytes)
echo "Biggest overall response in bytes"
awk '{print $10}' NASA_Jul95.log | sort -n | tail -1

# Average response size (in bytes)
echo "Average response size in bytes"
awk '{sum+=$10} END {print sum/NR}' NASA_Jul95.log


# 9.There was a hurricane during August where there was no data collected. Identify the times and dates when data was not collected for August. How long was the outage?

log_dates=$(iconv -c -f utf-8 -t ascii NASA_Aug95.log | awk -F'[][]' '{split($2, a, ":"); print a[1]}' | sort | uniq)
august_dates=$(for d in $(seq -w 1 31); do echo "$d/Aug/1995"; done)

echo "Outage Dates in August:"
comm -23 <(echo "$august_dates" | sort) <(echo "$log_dates" | sort)


# 10. Which date saw the most activity overall?

echo "Most active date overall in July:"
iconv -c -f utf-8 -t ascii NASA_Jul95.log | \
awk -F'[][]' '{split($2, date, ":"); print date[1]}' | \
sort | uniq -c | sort -nr | head -1

echo ""
echo "Most active date overall in August:"
iconv -c -f utf-8 -t ascii NASA_Aug95.log | \
awk -F'[][]' '{split($2, date, ":"); print date[1]}' | \
sort | uniq -c | sort -nr | head -1

# 11. Excluding the outage dates which date saw the least amount of activity?
echo "Date that saw least acitivty excluding outage day" 
awk -F'\\[' '{print $2}' NASA_Aug95.log | cut -d: -f1 | \
grep -v -E '02/Aug/1995' | \
sort | uniq -c | sort -n | head -1