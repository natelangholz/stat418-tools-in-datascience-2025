#!/bin/bash
wget -nc https://atlas.cs.brown.edu/data/web-logs/NASA_Aug95.log
cd /data    #to data
for file in NASA_Jul95.log NASA_Aug95.log; do # refer specific files
  echo "Processing $file"
  echo "====="
  
  # 1. Top 10 websites (excluding 404s)
	echo "Top 10 hostnames/IPs (non-404):"
	awk '$9 != 404 { print $1 }' "hw1/$file" | sort | uniq -c | sort -rn | head -10
	echo ""
	
	# 2. IP vs Hostname (%)
	echo "Percentage of requests from IP vs Hostname:"
	total=$(wc -l < "hw1/$file")
	ip_count=$(awk '$1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/' "hw1/$file" | wc -l)
	host_count=$((total - ip_count))
	ip_percent=$(awk "BEGIN { printf \"%.2f\", ($ip_count/$total)*100 }")
	host_percent=$(awk "BEGIN { printf \"%.2f\", ($host_count/$total)*100 }")
	echo "IP: $ip_percent% | Hostname: $host_percent%"
	echo ""
	
	# 3. top 10 requests (non-404 status).
	echo "Top 10 requests (non-404 status):"
	awk '$9 != 404 { print $7 }' "hw1/$file" | sort | uniq -c | sort -rn | head -10

  # 4. most frequent request types
  awk '$9 != 404 { print substr($6, 2) }' "hw1/$file" | sort | uniq -c | sort -rn | head -1

  # 5. 404 errors
  awk '$9 == 404' "hw1/$file" | wc -l
  
  # 6. What is the most frequent response code and what percentage of reponses did this account for?
  total=$(wc -l < "hw1/$file")
  read most_frequent_code_count response_code <<< $(awk '{ print $9 }' "hw1/$file" | sort | uniq -c | sort -rn | head -1)
  percent=$(awk "BEGIN {printf \"%.2f\", ($most_frequent_code_count/$total)*100 }")
	echo "most frequent code: $response_code"
	echo "most frequent code count: $most_frequent_code_count"
	echo "percentage: $percent%"
	
	# 7. What time of day is the site active? When is it quiet?
	awk -F: '{split($2, date, "["); hour=date[2]; print hour}' "hw1/$file" | sort | uniq -c
	echo "It seems that from 23:00 to 07:00 is relatively quieter than other hours."
	
	# 8. What is the biggest overall response (in bytes) and what is the average?
	awk '
  $10 ~ /^[0-9]+$/ {
    sum += $10
    count++
    if ($10 > max) {
      max = $10
      max_line = $0   # Store the full line
    }
  }
  END {
    print "Max response size:", max
    print "Full response line:"
    print max_line
    print "Average response size:", int(sum / count)
  }
' "hw1/$file"

	# 9.There was a hurricane during August where there was no data collected. 
	#   Identify the times and dates when data was not collected for August. 
	#   How long was the outage? 
	awk '{ 
  match($4, /\[([0-9]{2}\/[A-Za-z]+\/[0-9]{4}):([0-9]{2})/, arr)
  date_hour = arr[1] " " arr[2]
  count[date_hour]++
}
END {
  for (h = 0; h < 24; h++) {
    for (d = 1; d <= 31; d++) {
      day = (d < 10 ? "0" d : d)
      for (m = 1; m <= 12; m++) {
        month = "Aug"
        year = "1995"
        key = day "/" month "/" year " " (h < 10 ? "0" h : h)
        if (!(key in count)) {
          missing++
          print "Missing:", key
        }
      }
    }
  }
  print "Total missing hours:", missing
}' "hw1/NASA_Aug95.log"

	# 10. Which date saw the most activity overall? 
	awk '{ gsub("\\[", "", $4); print $4 }' hw1/NASA_Aug95.log | cut -d: -f1 | sort | uniq -c | sort -rn | head -1


	# 11. Excluding the outage dates which date saw the least amount of activity?
	awk '{ gsub("\\[", "", $4); print $4 }' hw1/NASA_Aug95.log \
  | cut -d: -f1 \
  | sort | uniq -c | sort -n | head -1


done





