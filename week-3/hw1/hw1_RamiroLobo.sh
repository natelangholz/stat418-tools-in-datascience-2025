#!/bin/bash

# Check if file is provided and valid
if [[ "$1" != "NASA_Jul95.log" && "$1" != "NASA_Aug95.log" ]]; then
  echo "Usage: $0 NASA_Jul95.log or NASA_Aug95.log"
  exit 1
fi

logfile=$1
is_august=false
[[ "$logfile" == *Aug95* ]] && is_august=true

###########
#Question 1
###########

echo 'Question 1:'
echo 'Top 10 websites:'
awk '$9 != 404 && $1 !~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/ {print $1}' "$logfile" | sort | uniq -c | sort -rn | head -n 10  

###########
#Question 2
###########

echo -e '\nQuestion 2:'

total=$(wc -l < "$logfile")
ip=$(awk '$1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/' "$logfile" | wc -l)
host=$((total - ip))

per_ip=$(echo "scale=4; $ip / $total * 100" | bc)
per_host=$(echo "scale=4; $host / $total * 100" | bc)

printf "Total Lines: %s\n" "$total"
printf "Percent from IP: %.2f%%\n" "$per_ip"
printf "Percent from hostname: %.2f%%\n" "$per_host"

###########
#Question 3
###########

echo -e "\nQuestion 3"
echo 'Top 10 requests:'

awk '$9 != 404 { print $7 }' "$logfile" | sort | uniq -c | sort -rn | head -n 10  

###########
#Question 4
###########

echo -e "\nQuestion 4"

echo "Most frequent request types: "
awk '{ print $6 }' "$logfile" | tr -d '"' | sort | uniq -c | sort -rn | head -n 3  

###########
#Question 5
###########

echo -e "\nQuestion 5"

errors=$(awk '$9 == 404' "$logfile" | wc -l)
echo "Total 404 errors: $errors"

###########
#Question 6
###########

echo -e "\nQuestion 6"

code_n=$(awk '{ print $9 }' "$logfile" | sort | uniq -c | sort -rn | head -n 1 | awk '{print $1}')
code=$(awk '{ print $9 }' "$logfile" | sort | uniq -c | sort -rn | head -n 1 | awk '{print $2}')

per_code=$(echo "scale=4; $code_n / $total * 100" | bc)

printf "Most frequent response code: %s\n" "$code"
printf "Percent of responses with code %s: %.2f%%\n" "$code" "$per_code"

###########
#Question 7
###########

echo -e "\nQuestion 7"

echo "Five most frequent request times (HH:MM, excluding seconds):"
awk '{print $4}' "$logfile" | cut -d":" -f2-3 | sort | uniq -c | sort -rn | head -n 5

echo "Five least frequent request times (HH:MM, excluding seconds):"
awk '$4 != "" {print $4}' "$logfile" | cut -d":" -f2-3 | sort | uniq -c | sort -n | head -n 5

###########
#Question 8
###########

echo -e "\nQuestion 8"

largest=$(awk '{print $10}' "$logfile" | sort -rn | head -n 1)
sum=$(awk '{sum += $10} END {print sum}' "$logfile")
average=$(echo "scale=2; $sum / $total" | bc)

echo "The largest overall response was $largest bytes."
echo "The average response size was $average bytes."

###########
#Question 9
###########

echo -e "\nQuestion 9"

if [ "$is_august" = true ]; then
  echo "Checking for outage days in August logs..."
  
  dates_Aug=$(awk '{print $4}' "$logfile" | cut -d"/" -f1-2 | sort | uniq -c)
  echo "$dates_Aug"

  echo -e "\nLast log on August 1:"
  awk '{print $4}' "$logfile" | awk -F'/' '$1 == "[01"' | sort -r | head -n 1 | tr -d '[]'

  echo -e "\nFirst log on August 3:"
  awk '{print $4}' "$logfile" | awk -F'/' '$1 == "[03"' | sort | head -n 1 | tr -d '[]'

  echo -e "\nThe outage began at 2:52PM on August 1st and ended at 4:36AM on August 3rd, lasting approximately 37 hours."
else
  echo "No outage check needed; this is not the August file."
fi

###########
#Question 10
###########

echo -e "\nQuestion 10"

top_date=$(awk '{print $4}' "$logfile" | cut -d"/" -f1-2 | sort | uniq -c | sort -rn | head -n 1 | awk '{print $2}' | tr -d "[]")
echo "The most active date was $top_date."

###########
#Question 11
###########

echo -e "\nQuestion 11"

if [ "$is_august" = true ]; then
  echo "Excluding August 1–3 from least-active date check..."
  least_date=$(awk '{print $4}' "$logfile" | cut -d"/" -f1-2 | grep -vE "\[01/Aug|\[02/Aug|\[03/Aug" | sort | uniq -c | sort -n | head -n 1 | awk '{print $2}' | tr -d "[]")
else
  least_date=$(awk '{print $4}' "$logfile" | awk '$1 != ""' | cut -d"/" -f1-2 | sort | uniq -c | sort -n | head -n 1 | awk '{print $2}' | tr -d "[]")
fi

echo "The least active date was $least_date."
