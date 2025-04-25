#!/bin/bash

echo "=================================================="
### July 95
# 1 List the top 10 web sites from which requests came (non-404 status).
echo "July - Top 10 Websites that Requests Came From:"
awk '{print $1}' NASA_Jul95.log | sort | uniq -c | sort -nr | head -n 10 | awk '{print $2}'

echo "--------------------------------------------------"
# 2 What percentage of host requests came from IP vs hostname?
# Total entries (first field only)
total=$(awk '{print $1}' NASA_Jul95.log | wc -l)

# IP address entries
ips=$(awk '{print $1}' NASA_Jul95.log | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)

# Hostname entries (not IPs)
hosts=$(awk '{print $1}' NASA_Jul95.log | grep -vE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)

# Compute percentages
ip_pct=$(awk -v i="$ips" -v t="$total" 'BEGIN { printf "%.2f", (i/t)*100 }')
host_pct=$(awk -v h="$hosts" -v t="$total" 'BEGIN { printf "%.2f", (h/t)*100 }')

# Output results
echo "For NASA_Jul95.log:"
echo "Total entries: $total"
echo "IP addresses: $ips ($ip_pct%)"
echo "Hostnames: $hosts ($host_pct%)"

echo "--------------------------------------------------"
# 3
echo "July - Top 10 Requests:"
iconv -c -f utf-8 -t utf-8 NASA_Jul95.log > clean_NASA_Jul95.log
awk -F'"' '{print $2}' clean_NASA_Jul95.log | sort | uniq -c | sort -nr | head -n 10 | awk '{print $2, $3, $4}'

echo "--------------------------------------------------"
# 4  List the most frequent request types?
echo "July - Most Frequent Request Types:"
awk -F'"' '{split($2, a, " "); print a[1]}' clean_NASA_Jul95.log | sort | uniq -c | sort -nr | head -n 3 | awk '{print $2}'

echo "--------------------------------------------------"
# 5 How many 404 errors were reported in the log?
awk -v var="July - Number of 404 errors:" '$9 == 404 {count++} END {print var, count}' clean_NASA_Jul95.log

echo "--------------------------------------------------"
# 6
awk '{print $9}' clean_NASA_Jul95.log | sort | uniq -c | sort -nr | head -n 1 | awk '{print "July - Most frequent response code:", $2}'

echo "--------------------------------------------------"
# 7  What time of day is the site active? When is it quiet?
awk '{
    # Remove the leading "[" from the timestamp
    gsub(/^\[/, "", $4)
    
    # Split the date-time field into date and time
    split($4, datetime, ":")
    
    # Extract hours, minutes, seconds and convert to seconds
    hours = datetime[2]
    minutes = datetime[3]
    seconds = datetime[4]
    total_seconds += (hours * 3600 + minutes * 60 + seconds)
    count++
}
END {
    avg = total_seconds / count
    # Convert avg seconds back to HH:MM:SS
    h = int(avg / 3600)
    m = int((avg % 3600) / 60)
    s = int(avg % 60)
    printf "July - Average time of server calls: %02d:%02d:%02d\n", h, m, s
}' nasa_Jul95.log
echo "The average server call time is ~1:00 PM, implying that calls are most active during the day and least activr at night"
# The average time is 13:11:12, suggesting that the site is most active during the day, and less active at night.

echo "--------------------------------------------------"
# 8 What is the biggest overall response (in bytes) and what is the average?
awk '{if($9 ~ /^[0-9]+$/ && $9 > max) max = $9} END {print "July - Highest status code:", max}' clean_NASA_Jul95.log
awk '$10 ~ /^[0-9]+$/ {sum += $10; count++} END {if (count > 0) printf "July - Average response size: %.2f bytes\n", sum / count}' clean_NASA_Jul95.log

# 9 There was a hurricane during August where there was no data collected. Identify the times and dates when data was not collected for August. How long was the outage?
# Aug 2nd is missing from the logs, assuming that the hurricane happened on Aug 2nd

echo "--------------------------------------------------"
# 10 Which date saw the most activity overall?
awk '{split($4, a, "/"); print a[1]}' clean_NASA_Jul95.log | sort | uniq -c | sort -nr | head -n 1 | awk '{print "July - Most frequent date:", $2}'

echo "--------------------------------------------------"
# 11 Excluding the outage dates which date saw the least amount of activity?
awk '{gsub(/^\[/, "", $4); split($4, parts, ":"); date = parts[1]; count[date]++} 
     END {
         max = 0
         for (d in count) {
             if (count[d] > max) {
                 max = count[d]
                 max_date = d
             }
         }
         print "Most active date in July:", max_date, "with", max, "requests"
     }' clean_NASA_Jul95.log

echo "=================================================="

### Aug 95
# 1 List the top 10 web sites from which requests came (non-404 status).
echo "August - Top 10 Websites that Requests Came From:"
awk '{print $1}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -n 10 | awk '{print $2}'
echo "--------------------------------------------------"

# 2  What percentage of host requests came from IP vs hostname?
# Total entries (first field only)
totalAUG=$(awk '{print $1}' NASA_Aug95.log | wc -l)

# IP address entries
ipsAUG=$(awk '{print $1}' NASA_Aug95.log | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)

# Hostname entries (not IPs)
hostsAUG=$(awk '{print $1}' NASA_Aug95.log | grep -vE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)

# Compute percentages
ip_pctAUG=$(awk -v i="$ipsAUG" -v t="$totalAUG" 'BEGIN { printf "%.2f", (i/t)*100 }')
host_pctAUG=$(awk -v h="$hostsAUG" -v t="$totalAUG" 'BEGIN { printf "%.2f", (h/t)*100 }')

# Output results
echo "For NASA_Aug95.log:"
echo "Total entries: $totalAUG"
echo "IP addresses: $ipsAUG ($ip_pctAUG%)"
echo "Hostnames: $hostsAUG ($host_pctAUG%)"

echo "--------------------------------------------------"
# 3
echo "August - Top 10 Requests:"
iconv -c -f utf-8 -t utf-8 NASA_Aug95.log > clean_NASA_Aug95.log
awk -F'"' '{print $2}' clean_NASA_Aug95.log | sort | uniq -c | sort -nr | head -n 10 | awk '{print $2, $3, $4}'

echo "--------------------------------------------------"
# 4  List the most frequent request types?
echo "August - Most Frequent Request Types:"
awk -F'"' '{split($2, a, " "); print a[1]}' clean_NASA_Aug95.log | sort | uniq -c | sort -nr | head -n 3 | awk '{print $2}'

echo "--------------------------------------------------"
# 5 How many 404 errors were reported in the log?
awk -v var="August - Number of 404 errors:" '$9 == 404 {count++} END {print var, count}' clean_NASA_Aug95.log

echo "--------------------------------------------------"
# 6
awk '{print $9}' clean_NASA_Aug95.log | sort | uniq -c | sort -nr | head -n 1 | awk '{print "August - Most frequent response code:", $2}'

echo "--------------------------------------------------"
# 7  What time of day is the site active? When is it quiet?
awk '{
    # Remove the leading "[" from the timestamp
    gsub(/^\[/, "", $4)
    
    # Split the date-time field into date and time
    split($4, datetime, ":")
    
    # Extract hours, minutes, seconds and convert to seconds
    hours = datetime[2]
    minutes = datetime[3]
    seconds = datetime[4]
    total_seconds += (hours * 3600 + minutes * 60 + seconds)
    count++
}
END {
    avg = total_seconds / count
    # Convert avg seconds back to HH:MM:SS
    h = int(avg / 3600)
    m = int((avg % 3600) / 60)
    s = int(avg % 60)
    printf "August - Average time of server calls: %02d:%02d:%02d\n", h, m, s
}' nasa_Aug95.log
echo "The average server call time is ~1:00 PM, implying that calls are most active during the day and least activr at night"
# The average time is 13:11:12, suggesting that the site is most active during the day, and less active at night.

echo "--------------------------------------------------"
# 8 What is the biggest overall response (in bytes) and what is the average?
awk '{if($9 ~ /^[0-9]+$/ && $9 > max) max = $9} END {print "August - Highest status code:", max}' clean_NASA_Aug95.log
awk '$10 ~ /^[0-9]+$/ {sum += $10; count++} END {if (count > 0) printf "August - Average response size: %.2f bytes\n", sum / count}' clean_NASA_Aug95.log

# 9 There was a hurricane during August where there was no data collected. Identify the times and dates when data was not collected for August. How long was the outage?
# Aug 2nd is missing from the logs, assuming that the hurricane happened on Aug 2nd

echo "--------------------------------------------------"
# 10 Which date saw the most activity overall?
awk '{split($4, a, ":"); print a[1]}' clean_NASA_Aug95.log | sort | uniq -c | sort -nr | head -n 1 | awk '{print "August - Most frequent date:", $2}' 

echo "--------------------------------------------------"
# 11 Excluding the outage dates which date saw the least amount of activity?
awk '{gsub(/^\[/, "", $4); split($4, parts, ":"); date = parts[1]; count[date]++} 
     END {
         max = 0
         for (d in count) {
             if (count[d] > max) {
                 max = count[d]
                 max_date = d
             }
         }
         print "Most active date in August:", max_date, "with", max, "requests"
     }' clean_NASA_Aug95.log
