#!/bin/bash

for LOGFILE in NASA_Jul95.log NASA_Aug95.log; do
  export LC_ALL=C

  echo "Processing: $LOGFILE"
  echo "======================================="

  # 1. Top 10 websites (non-404)
  echo "1. Top 10 hosts (non-404):"
  awk '$9 != 404 {print $1}' "$LOGFILE" | sort | uniq -c | sort -nr | head -10
  echo

  # 2. IP vs Hostname
  echo "2. IP vs Hostname (% of host requests):"
  total=$(awk '{print $1}' "$LOGFILE" | wc -l)
  ip_count=$(awk '{print $1}' "$LOGFILE" | grep -Eo '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)
  host_count=$((total - ip_count))
  ip_pct=$(awk -v ip="$ip_count" -v total="$total" 'BEGIN {printf "%.2f", (ip/total)*100}')
  host_pct=$(awk -v host="$host_count" -v total="$total" 'BEGIN {printf "%.2f", (host/total)*100}')
  echo "IP: $ip_pct% ; Hostname: $host_pct%"
  echo

  # 3. Top 10 requests (non-404)
  echo "3. Top 10 requests (non-404):"
  awk '$9 != 404 {print $7}' "$LOGFILE" | sort | uniq -c | sort -nr | head -10
  echo

  # 4. Most frequent request types
  echo "4. Most frequent request types:"
  awk '{print $6}' "$LOGFILE" | sed 's/"//' | sort | uniq -c | sort -nr
  echo

  # 5. Number of 404 errors
  echo "5. Total 404 errors:"
  awk '$9 == 404' "$LOGFILE" | wc -l
  echo

  # 6. Most frequent response code and %
  echo "6. Most frequent response code and %:"
  awk '{print $9}' "$LOGFILE" | sort | uniq -c | sort -nr | head -1 | while read count code; do
    total_resp=$(awk '{print $9}' "$LOGFILE" | wc -l)
    pct=$(awk -v c="$count" -v t="$total_resp" 'BEGIN {printf "%.2f", (c/t)*100}')
    echo "$code occurred $count times (${pct}%)"
  done
  echo

  # 7. Active and quiet time of day
  echo "7. Active and quiet time of day (HH):"
  awk -F: '{print $2}' "$LOGFILE" | sort | uniq -c | sort -nr | head -1
  awk -F: '{print $2}' "$LOGFILE" | sort | uniq -c | sort -n | head -1
  echo

  # 8. Max and average response size
  echo "8. Max and average response size (bytes):"
  awk '$10 ~ /^[0-9]+$/ {sum += $10; if ($10 > max) max = $10; count++} END {printf "Max: %d bytes | Avg: %.2f bytes\n", max, sum/count}' "$LOGFILE"
  echo

  # 9. Identify data outage (August only)
  if [[ "$LOGFILE" == *"Aug95"* ]]; then
    echo "9. Hurricane outage detection:"
    awk '{print substr($4, 2)}' "$LOGFILE" | sort | uniq | \
    awk '
    function to_epoch(ts,   a, month) {
      split(ts, a, "[:/]")
      month["Jan"]=1; month["Feb"]=2; month["Mar"]=3; month["Apr"]=4
      month["May"]=5; month["Jun"]=6; month["Jul"]=7; month["Aug"]=8
      month["Sep"]=9; month["Oct"]=10; month["Nov"]=11; month["Dec"]=12
      return mktime(a[3] " " month[a[2]] " " a[1] " " a[4] " " a[5] " " a[6])
    }

    NR == 1 {
      prev = $0
      prev_sec = to_epoch($0)
      next
    }

    {
      curr = $0
      curr_sec = to_epoch($0)
      gap = curr_sec - prev_sec
      if (gap > 3600) {
        print "Outage from " prev " to " curr " = " int(gap / 3600) " hours"
      }
      prev = curr
      prev_sec = curr_sec
    }'
    echo
  fi

  # 10. Date with most activity
  echo "10. Date with most activity:"
  awk '{print $4}' "$LOGFILE" | cut -d: -f1 | sed 's/\[//' | sort | uniq -c | sort -nr | head -1
  echo

  # 11. Date with least (non-zero) activity
  echo "11. Date with least activity (excluding outage):"
  awk '{print $4}' "$LOGFILE" | cut -d: -f1 | sed 's/\[//' | sort | uniq -c | awk '$1 > 0' | sort -n | head -1
  echo

done

