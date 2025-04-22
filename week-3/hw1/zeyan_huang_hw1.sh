#!/bin/bash

for file in *.log; do
  echo "Processing file: $file"
  echo "-----------------------------------------"

  # Q1: Top 10 websites from which requests came (non-404)
  echo "Q1: Top 10 hostnames (non-404):"
  awk '$9 != 404 {print $1}' "$file" | sort | uniq -c | sort -nr | head -10
  echo

  # Q2: Percentage of requests from IPs vs hostnames
  echo "Q2: Percentage of requests from IPs vs hostnames:"
  total=$(awk '{print $1}' "$file" | wc -l)
  ip_count=$(awk '{print $1}' "$file" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)
  hostname_pct=$(echo "scale=2; 100 * ($total - $ip_count) / $total" | bc)
  ip_pct=$(echo "scale=2; 100 * $ip_count / $total" | bc)
  echo "Hostname: $hostname_pct% | IP: $ip_pct%"
  echo

  # Q3: Top 10 requests (non-404)
  echo "Q3: Top 10 requests (non-404):"
  awk '$9 != 404 {print $7}' "$file" | iconv -c -f utf-8 -t ascii | sort | uniq -c | sort -nr | head -10
  echo

  # Q4: Most frequent request types
  echo "Q4: Most frequent request types:"
  awk '{print $6}' "$file" | iconv -c -f utf-8 -t ascii | tr -d '"' | sort | uniq -c | sort -nr | head -1
  echo

  # Q5: Count of 404 errors
  echo "Q5: Total 404 errors:"
  awk '$9 == 404' "$file" | wc -l
  echo

  # Q6: Most frequent response code + percentage
  echo "Q6: Most frequent response code:"
  awk '{print $9}' "$file" | sort | grep -E '^[0-9]+$' | sort | uniq -c | sort -nr | head -1 | while read count code; do
    pct=$(echo "scale=2; 100 * $count / $total" | bc)
    echo "$code with $count occurrences ($pct%)"
  done
  echo

  # Q7: Active & quiet hours
  echo "Q7: Activity by hour:"
  awk -F: '$2 ~ /^[0-9]+$/ {print $2}' "$file" | sort | uniq -c | sort -nr
  echo

  # Q8: Biggest and average response size
  echo "Q8: Biggest and average response size:"
  awk '$10 ~ /^[0-9]+$/ {sum += $10; if ($10 > max) max = $10} END {avg = sum / NR; print "Max:", max, "| Avg:", avg}' "$file"
  echo "-----------------------------------------"
  echo
done


# Q9: Gaps in August logs

echo "Q9: Finding outage gaps in August..."
# Step 1: Extract present dates from the log
awk '{print $4}' NASA_Aug95.log | cut -d: -f1 | tr -d '[' | sort | uniq > present_dates.txt

# Step 2: Generate expected full list of dates for August 1995
for d in $(seq -w 1 31); do
    echo "$d/Aug/1995"
done > full_aug_dates.txt

# Step 3: Compare and print missing dates
echo "Missing dates in August 1995:"
comm -23 full_aug_dates.txt present_dates.txt


# Q10: Date with most activity
echo "Q10: Date with most activity:"
awk '{print $4}' NASA_Aug95.log | cut -d: -f1 | tr -d '[' | sort | uniq -c | sort -nr | head -1
echo

# Q11: Date with least activity (excluding 0)
echo "Q11: Date with least activity (non-outage):"
awk '{print $4}' NASA_Aug95.log | cut -d: -f1 | tr -d '[' | sort | uniq -c | sort -n | awk '$1 > 0'| head -1
echo