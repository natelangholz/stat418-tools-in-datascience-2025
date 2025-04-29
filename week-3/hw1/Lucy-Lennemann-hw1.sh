#!/bin/bash

# Lucy Lennemann, STATS 418
# Homework 1

# USAGE: run ./my-script.sh FILE where FILE is either NASA_Jul95.log or NASA_Aug95.log

export LC_ALL=C # prevent illegal byte sequence
file=$1

echo $file
# (1) top 10 websites from which requests came, non-404 status
echo "--------------------------------------------------"
echo "Question 1: top 10 request websites, non-404 status"
awk '{if($(NF-1)!='404'){print $1}}' $file | sort | uniq -c | sort -nr | head -n 10

echo "--------------------------------------------------"
echo "Question 2: percentage of host requests from IP vs hostname"
total=$(wc -l < $file)										 # total host requests
ip=$(cut -d" " -f1 $file | grep -E '([0-9]+\.){3}[0-9]+' | wc -l)
host=$(cut -d" " -f1 $file | grep -E -v '([0-9]+\.){3}[0-9]+' | wc -l)
ip_percent=$(echo "scale=5;$ip/$total" | bc -l)
host_percent=$(echo "scale=5;$host/$total" | bc -l)
echo "Percent of requests with IP addresses: " $ip_percent						
echo "Percent of requests with hostnames: " $host_percent		 

echo "--------------------------------------------------"
echo "Question 3: top 10 requests, non-404 status"
awk '{if($(NF-1)!='404'){print $0}}' $file | cut -d'"' -f2 | sort | uniq -c | sort -nr | head -n 10

echo "--------------------------------------------------"
echo "Question 4: most frequent request types" 
cut -d'"' -f2 $file | cut -d" " -f1 | sort | uniq -c | sort -rn | head -n 3

echo "--------------------------------------------------"
echo "Question 5: how many 404 errors"
awk '{print $(NF-1)}' $file | sort | uniq -c | awk '{if($2=='404'){print $1}}'

echo "--------------------------------------------------"
echo "Question 6: most frequent response code and percentage of responses that counted for"
rescode=$(awk '{print $(NF-1)}' $file | sort | uniq -c | sort -nr | head -1)
code=$(echo $rescode | awk '{print $1}')
num=$(echo $rescode | awk '{print $2}')
echo "Most frequent response code: " $num
echo "Percentage of responses that counted for: "
echo "scale=5;$code/$total" | bc -l

echo "--------------------------------------------------"
echo "Question 7: time of day when the most active? when the most silent?"
echo "Times of the day sorted by most active to least active: "
cut -d" " -f4 $file | awk -F ":" '{print $2}' | sort | uniq -c | sort -nr

echo "--------------------------------------------------"
echo "Question 8: biggest overall response in bytes and the average?"
bytes=$(awk '{print $NF}' $file | sort -nr | head -1)
echo "Biggest overall response in bytes: " $bytes
total=$(awk '{print $NF}' $file | awk '{sum+=$1} END {print sum}')				# average
line_ct=$(wc -l $file | awk '{print $1}')
average=$(echo "scale=5;$total/$line_ct" | bc -l)
echo "Average: " $average

echo "--------------------------------------------------"
echo "Question 9: times and dates that the outage happened?"
if [[ "$file" == 'NASA_Aug95.log' ]]; then
cut -d" " -f4 NASA_Aug95.log | awk -F ":" '{print $1}' | sort | uniq -c
#command to figure out times of the outage
#cut -d" " -f4 NASA_Aug95.log | awk -F ":" '$1 == "[01/Aug/1995" || $1 == "[03/Aug/1995"{print $1","$2":"$3}' | uniq -c
echo "Outage happened from August 1 2:52pm to August 3 4:36am"
fi

echo "--------------------------------------------------"
echo "Question 10: date with the most activity overall?"
days=$(cut -d"[" -f2 $file | cut -d":" -f1 | uniq -c | sort -nr | head -n 1)
echo "Date with most activity: " $days

echo "--------------------------------------------------"
echo "Question 11: excluding the outage dates, date with the least activity overall?"
if [[ "$file" == 'NASA_Aug95.log' ]]; then
cut -d"[" -f2 $file | cut -d":" -f1 | uniq -c | sort -nr | grep -E -v "\[01/Aug|\[02/Aug|\[03/Aug" | tail -n 1
else
cut -d"[" -f2 $file | cut -d":" -f1 | uniq -c | sort -nr | grep -E -v "alyssa.p" | tail -n 1 # avoid noise
fi



