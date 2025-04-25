#!/bin/bash

# Usage: ./parse_logs.sh NASA_Jul95.log
# This script analyzes NASA access log files and answers 11 questions

LOGFILE=$1

if [[ ! -f "$LOGFILE" ]]; then
  echo "File not found: $LOGFILE"
  exit 1
fi

echo "Analyzing file: $LOGFILE"
echo "--------------------------------------------"

# 1. Top 10 web hosts making successful (non-404) requests
echo "1. Top 10 websites (non-404 requests):"
awk '$9 != 404 {print $1}' "$LOGFILE" | sort | uniq -c | sort -nr | head -10
echo "--------------------------------------------"

# 2. Percentage of requests from IPs vs hostnames
echo "2. IP vs Hostname percentage:"
awk '{
  if ($1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) ip++
  else host++
} END {
  total = ip + host
  printf "IP: %d (%.2f%%)\n", ip, ip/total*100
  printf "Host: %d (%.2f%%)\n", host, host/total*100
}' "$LOGFILE"
echo "--------------------------------------------"

# 3. Top 10 requests (non-404):
echo "3. Top 10 requests (non-404):"
LC_ALL=C grep -v ' 404 ' "$LOGFILE" \
  | grep -oE '"[A-Z]+ [^ ]+ HTTP/[0-9.]+"' \
  | cut -d' ' -f2 \
  | awk 'length($0) >= 3' \
  | sort \
  | uniq -c \
  | sort -nr \
  | head -10
echo "--------------------------------------------"

# 4. Most frequent request types:
echo "4. Most frequent request types:"
LC_ALL=C grep -oE '"(GET|POST|HEAD) ' "$LOGFILE" \
  | cut -d'"' -f2 \
  | awk '{ print $1 }' \
  | sort \
  | uniq -c \
  | sort -nr
echo "--------------------------------------------"


# 5. Total number of 404 errors
echo "5. Number of 404 errors:"
awk '$9 == 404' "$LOGFILE" | wc -l
echo "--------------------------------------------"

# 6. Response code frequencies:
echo "6. Response code frequencies (top 10):"
LC_ALL=C awk '
  # Only count numeric codes in field 9
  $9 ~ /^[0-9]+$/ { codes[$9]++ }

  END {
    total = 0
    # Compute grand total of all counted codes
    for (c in codes) total += codes[c]

    # Print each code with its count and percentage
    for (c in codes)
      printf "%s: %d (%.2f%%)\n", c, codes[c], (codes[c]/total)*100
  }
' "$LOGFILE" \
  | sort -nr -k2 \
  | head -10
echo "--------------------------------------------"

# 7. Requests per hour (activity level):
echo "7. Requests per hour (activity level):"

# 1) Extract hour from timestamp ([DD/Mon/YYYY:HH:MM:SS …])
# 2) Count requests per hour
counts=$(LC_ALL=C awk '{
    ts = $4
    sub(/^\[/, "", ts)            # strip leading “[”
    split(ts, parts, ":")         # parts[1]=DD/Mon/YYYY, parts[2]=HH, …
    hour = parts[2] ":00"
    print hour
  }' "$LOGFILE" \
  | sort \
  | uniq -c)

# 3) Most active hours (top 5)
echo "Most active hours (top 5):"
echo "$counts" \
  | sort -nr \
  | head -5 \
  | awk '{ printf "%s has %d requests\n", $2, $1 }'

# 4) Least active hours (bottom 5)
echo
echo "Quietest hours (bottom 5):"
echo "$counts" \
  | sort -n \
  | head -5 \
  | awk '{ printf "%s has %d requests\n", $2, $1 }'

echo "--------------------------------------------"

# 8. Max and average response size
echo "8. Max and average response size (bytes):"
awk '$10 ~ /^[0-9]+$/ {sum+=$10; count++; if ($10 > max) max=$10} END {
  printf "Max size: %d bytes\n", max
  printf "Average size: %.2f bytes\n", sum/count
}' "$LOGFILE"
echo "--------------------------------------------"

# 9. Outage detection
if [[ "$LOGFILE" == *"Aug95"* ]]; then
echo "9. Hurricane-related outage times:"

# 1) Extract unique present hours from the log
present_hours=$(LC_ALL=C awk -F'[' '
  $2 {
    split($2, a, ":")
    # a[1]=DD/Mon/YYYY, a[2]=HH
    printf "%s:%s:00\n", a[1], a[2]
  }
' "$LOGFILE" | sort -u)

# 2) Generate full list of all hours in August 1995
full_hours=$(for day in {01..31}; do
  for hour in {00..23}; do
    printf "%02d/Aug/1995:%02d:00\n" "$day" "$hour"
  done
done | sort)

# 3) Identify missing hours: full minus present
missing=$(comm -23 \
  <(printf "%s\n" "$full_hours") \
  <(printf "%s\n" "$present_hours"))

# 4) Output missing hours sorted newest first
printf "%s\n" "$missing" | sort

# 5) Total outage length
echo
echo "Total outage duration: $(printf "%s\n" "$missing" | wc -l) hours"
  echo "--------------------------------------------"
fi

# 10. Date with most activity:
echo "10. Date with most activity:"
LC_ALL=C awk '{
    ts = $4
    sub(/^\[/, "", ts)            # remove leading “[”
    split(ts, parts, ":")         # parts[1]=DD/Mon/YYYY
    print parts[1]
  }' "$LOGFILE" \
  | sort \
  | uniq -c \
  | sort -nr \
  | head -1 \
  | awk '{ printf "%s saw %d requests\n", $2, $1 }'
echo "--------------------------------------------"

# 11. Date with least activity (excluding 0):
echo "11. Date with the least activity (excluding 01–03/Aug/1995):"

LC_ALL=C awk '{
    ts = $4
    sub(/^\[/, "", ts)            # remove leading “[”
    split(ts, parts, ":")         # parts[1]=DD/Mon/YYYY
    print parts[1]
  }' "$LOGFILE" \
  | grep -v -E '^0[1-3]/Aug/1995$' \
  | sort \
  | uniq -c \
  | sort -n \
  | head -1 \
  | awk '{ printf "%s saw %d requests\n", $2, $1 }'
echo "--------------------------------------------"
