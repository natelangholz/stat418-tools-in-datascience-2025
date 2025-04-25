echo "STATS 418 HW 1"
echo "Name: Hengyuan (David) Liu"
echo ""

echo "1. List the top 10 web sites from which requests came (non-404 status) for NASA_Jul95:"
awk '$9 != 404 { print $1 }' NASA_Jul95.log | sort | uniq -c | sort -rn | head  
echo "" 
echo "1. List the top 10 web sites from which requests came (non-404 status) for NASA_Aug95:"
awk '$9 != 404 { print $1 }' NASA_Aug95.log | sort | uniq -c | sort -rn | head 
echo "\n-------\n"

echo "2. What percentage of host requests came from IP vs hostname for NASA_Jul95?"
total=$(wc -l < "NASA_Jul95.log")
ip_count=$(awk '$1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/' NASA_Jul95.log | wc -l)
host_count=$((total - ip_count))
ip_percent=$(awk "BEGIN { printf \"%.2f\", ($ip_count/$total)*100 }")
host_percent=$(awk "BEGIN { printf \"%.2f\", ($host_count/$total)*100 }")
echo "IP: $ip_percent% | Hostname: $host_percent%"
echo ""
echo "2. What percentage of host requests came from IP vs hostname for NASA_Aug95?"
total=$(wc -l < "NASA_Aug95.log")
ip_count=$(awk '$1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/' NASA_Aug95.log | wc -l)
host_count=$((total - ip_count))
ip_percent=$(awk "BEGIN { printf \"%.2f\", ($ip_count/$total)*100 }")
host_percent=$(awk "BEGIN { printf \"%.2f\", ($host_count/$total)*100 }")
echo "IP: $ip_percent% | Hostname: $host_percent%"
echo "\n-------\n"


echo "3. List the top 10 requests (non-404 status) for NASA_Jul95:"
awk '$9 != 404 {print $7}' NASA_Jul95.log | grep '^[[:print:]]*$' | tr -d '"' | sort | uniq -c | sort -nr | head -10
echo ""
echo "3. List the top 10 requests (non-404 status) for NASA_Aug95:"
awk '$9 != 404 {print $7}' NASA_Aug95.log | grep '^[[:print:]]*$' | tr -d '"' | sort | uniq -c | sort -nr | head -10
echo "\n-------\n"
#####

echo "4. List the most frequent request types for NASA_Jul95? "
LC_ALL=C awk '$9 != 404 { gsub(/"/, "", $6); print $6 }' NASA_Jul95.log | LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr | head -3
echo ""
echo "4. List the most frequent request types for NASA_Aug95? "
LC_ALL=C awk '$9 != 404 { gsub(/"/, "", $6); print $6 }' NASA_Aug95.log | LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr | head -3
echo "\n-------\n"
#####

echo "5. How many 404 errors were reported in the log for NASA_Jul95? "
awk '$9 == 404' NASA_Jul95.log | wc -l
awk '$9 == 404 { count++ } END { print "There are", count, "(404 errors) in NASA_Jul95.log." }' NASA_Jul95.log
echo ""
echo "5. How many 404 errors were reported in the log for NASA_Aug95? "
awk '$9 == 404' NASA_Aug95.log | wc -l
awk '$9 == 404 { count++ } END { print "There are", count, "(404 errors) in NASA_Aug95.log." }' NASA_Aug95.log
echo "\n-------\n"
####

echo "6. What is the most frequent response code and what percentage of reponses did this account for NASA_Jul95? "
total_responses=$(awk '{print $9}' NASA_Jul95.log | wc -l)
most_common=$(awk '{print $9}' NASA_Jul95.log | sort | uniq -c | sort -rn | head -1)
most_code=$(echo "$most_common" | awk '{print $2}')
most_count=$(echo "$most_common" | awk '{print $1}')
most_percent=$(awk "BEGIN { printf \"%.2f\", ($most_count / $total_responses) * 100 }")
echo "Code: $most_code | Count: $most_count | Percentage: $most_percent%"
echo ""
echo "6. What is the most frequent response code and what percentage of reponses did this account for NASA_Aug95? "
total_responses=$(awk '{print $9}' NASA_Aug95.log | wc -l)
most_common=$(awk '{print $9}' NASA_Aug95.log | sort | uniq -c | sort -rn | head -1)
most_code=$(echo "$most_common" | awk '{print $2}')
most_count=$(echo "$most_common" | awk '{print $1}')
most_percent=$(awk "BEGIN { printf \"%.2f\", ($most_count / $total_responses) * 100 }")
echo "Code: $most_code | Count: $most_count | Percentage: $most_percent%"
echo "\n-------\n"

echo "7. What time of day is the site active? When is it quiet for NASA_Jul95?"
awk -F: '{print $2}' NASA_Jul95.log | grep '^[0-9][0-9]$' | sort | uniq -c | sort -n
echo ""
echo "7. What time of day is the site active? When is it quiet for NASA_Aug95?"
awk -F: '{print $2}' NASA_Aug95.log | grep '^[0-9][0-9]$' | sort | uniq -c | sort -n
echo ""
echo "The most active time of day for NASA_Jul95 is between 10:00-16:00, and for NASA_Aug95 it is between 12:00-16:00."
echo "The quietest period for NASA_Jul95 is between 02:00-07:00, and for NASA_Aug95 it is between 01:00-05:00."
echo "\n-------\n"

echo " 8. What is the biggest overall response (in bytes) and what is the average for NASA_Jul95?"
max=$(awk '{ if($10 ~ /^[0-9]+$/) print $10 }' NASA_Jul95.log | sort -nr | head -1)
avg=$(awk '{ if($10 ~ /^[0-9]+$/) {sum += $10; count++} } END { if (count > 0) printf "%.2f", sum / count }' NASA_Jul95.log)
echo "Max: $max bytes | Avg: $avg bytes"
echo ""
echo " 8. What is the biggest overall response (in bytes) and what is the average for NASA_Aug95?"
max=$(awk '{ if($10 ~ /^[0-9]+$/) print $10 }' NASA_Aug95.log | sort -nr | head -1)
avg=$(awk '{ if($10 ~ /^[0-9]+$/) {sum += $10; count++} } END { if (count > 0) printf "%.2f", sum / count }' NASA_Aug95.log)
echo "Max: $max bytes | Avg: $avg bytes"
echo "\n-------\n"

echo "9.There was a hurricane during August where there was no data collected. Identify the times and dates when data was not collected for August. How long was the outage?"
LC_ALL=C awk -F'[\\[/:]' '{ if ($3 == "Aug" && $4 == "1995") seen[$2"/"$3"/"$4]++ }
  END {
    for (d = 1; d <= 31; d++) {
      day = sprintf("%02d", d)
      date = day "/Aug/1995"
      status = (date in seen ? "present" : "MISSING")
      printf "%s: %s\n", date, status
    }
  }' NASA_Aug95.log
start_time=$(awk '$4 ~ /01\/Aug\/1995/ {gsub(/\[/, "", $4); print $4 }' NASA_Aug95.log | sort | tail -1)
end_time=$(awk '$4 ~ /03\/Aug\/1995/ {gsub(/\[/, "", $4); print $4 }' NASA_Aug95.log | sort | head -1)
start_epoch=$(date -j -f "%d/%b/%Y:%H:%M:%S" "$start_time" +"%s" 2>/dev/null || date -d "$start_time" +"%s")
end_epoch=$(date -j -f "%d/%b/%Y:%H:%M:%S" "$end_time" +"%s" 2>/dev/null || date -d "$end_time" +"%s")
duration=$((end_epoch - start_epoch))
hours=$((duration / 3600))
minutes=$(((duration % 3600) / 60))
seconds=$((duration % 60))
echo "   Outage period: from $start_time to $end_time"
echo "   Duration: $hours hours, $minutes minutes, $seconds seconds"
echo "\n-------\n"

echo "10. Which date saw the most activity overall for NASA_Jul95?"
awk '{print $4}' NASA_Jul95.log | cut -d: -f1 | tr -d '[' | sort | uniq -c | sort -rn | head -1
echo "The most activity for NASA_Jul95.log occurred on July 13th, 1995."
echo ""
echo "10. Which date saw the most activity overall for NASA_Aug95?"
awk '{print $4}' NASA_Aug95.log | cut -d: -f1 | tr -d '[' | sort | uniq -c | sort -rn | head -1
echo "The most activity for NASA_Aug95.log occurred on August 31th, 1995."
echo "\n-------\n"

echo "11. Excluding the outage dates which date saw the least amount of activity for NASA_Jul95?"
awk '{print $4}' NASA_Jul95.log | cut -d: -f1 | tr -d '[' | sort | uniq -c | sort -nr | tail -3
echo ""
echo "11. Excluding the outage dates which date saw the least amount of activity for NASA_Aug95?"
awk '{print $4}' NASA_Aug95.log | cut -d: -f1 | tr -d '[' | sort | uniq -c | sort -nr | tail -3
echo "The lowest activity for NASA_Jul95.log occurred on July 28th, 1995."  
echo "The lowest activity for NASA_Aug95.log occurred on August 26th, 1995."
echo "\n----END----\n"
