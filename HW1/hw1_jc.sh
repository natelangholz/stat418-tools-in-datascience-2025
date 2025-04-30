#!/bin/bash

# Homework 1 – NASA Web Logs Analysis
# Author: Jannet Castaneda
# Due: April 22, 2025
# Instructions: Run this script from within the directory containing NASA_Jul95.log and NASA_Aug95.log

FILES=("NASA_Jul95.log" "NASA_Aug95.log")

for FILE in "${FILES[@]}"; do
  echo "Analyzing $FILE"
  echo "======================"

  # 1. Top 10 web sites from which requests came (non-404 only)
  echo "1. Top 10 web sites (non-404):"
  awk '$9 != 404 {print $1}' "$FILE" | sort | uniq -c | sort -nr | head -10

  # 2. Percentage of host requests from IP vs hostname
  echo "2. Percentage of IP vs Hostname:"
  TOTAL=$(awk '{print $1}' "$FILE" | wc -l)
  IPS=$(awk '{print $1}' "$FILE" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)
  echo "IP: $(echo "scale=2; $IPS/$TOTAL*100" | bc)%"
  echo "Hostname: $(echo "scale=2; (1 - $IPS/$TOTAL)*100" | bc)%"

  # 3. Top 10 requests (non-404)
  echo "3. Top 10 requests (non-404):"
  awk '$9 != 404 {print $7}' "$FILE" | sort | uniq -c | sort -nr | head -10

  # 4. Most frequent request types
  echo "4. Most frequent request types:"
  awk '{print $6}' "$FILE" | cut -d\" -f2 | cut -d" " -f1 | sort | uniq -c | sort -nr

  # 5. Number of 404 errors
  echo "5. Number of 404 errors:"
  awk '$9 == 404' "$FILE" | wc -l

  # 6. Most frequent response code and percentage
  echo "6. Most frequent response code and its percentage:"
  awk '{print $9}' "$FILE" | sort | uniq -c | sort -nr | head -1 | while read count code; do
    PERCENT=$(echo "scale=2; $count/$TOTAL*100" | bc)
    echo "Code: $code | Count: $count | Percentage: $PERCENT%"
  done

  # 7. Active vs Quiet time of day (hourly breakdown)
  echo "7. Active vs Quiet hours (hour in [HH]):"
  awk -F: '{print $2}' "$FILE" | sort | uniq -c | sort -nr | head -5 | sed 's/^/Most active: /'
  awk -F: '{print $2}' "$FILE" | sort | uniq -c | sort -n | head -5 | sed 's/^/Least active: /'

  # 8. Max and average response size
  echo "8. Max and average response size:"
  awk '$10 ~ /^[0-9]+$/ {sum += $10; count++; if ($10 > max) max = $10} END {print "Max: " max " bytes"; print "Average: " int(sum/count) " bytes"}' "$FILE"

  echo ""
done

# 9. August outage detection
echo "9. August outage detection:"
awk '{print $4}' NASA_Aug95.log | cut -d: -f1 | sort | uniq -c > dates.txt
# Convert this to list gaps manually or enhance with Python or Bash datetime detection
echo "(Check 'dates.txt' for gaps in dates to find outage period)"

# 10. Date with most activity
echo "10. Date with most activity:"
awk '{print $4}' NASA_Aug95.log NASA_Jul95.log | cut -d: -f1 | sort | uniq -c | sort -nr | head -1

# 11. Date with least activity (excluding gaps/outage)
echo "11. Date with least activity (excluding 0s):"
awk '{print $4}' NASA_Aug95.log NASA_Jul95.log | cut -d: -f1 | sort | uniq -c | awk '$1 > 0' | sort -n | head -1


