#!/bin/bash
if test -f "NASA_Jul95.log" && test -f "NASA_Aug95.log"; then
    echo "Logs already exist."
else
    echo "Downloading logs..."
    curl -s https://atlas.cs.brown.edu/data/web-logs/NASA_Jul95.log > NASA_Jul95.log
    curl -s https://atlas.cs.brown.edu/data/web-logs/NASA_Aug95.log > NASA_Aug95.log
fi

## Question 1 ##
echo -e "\n\n--- Top 10 Requesting Websites ---"
echo "Top 10 requesting websites in July 1995 (excluding 404 errors):"
awk '$9 != 404 && $1 !~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/ {print $1}' NASA_Jul95.log | sort | uniq -c | sort -nr | head -n 10

echo -e "\nTop 10 requesting websites in August 1995 (excluding 404 errors):"
awk '$9 != 404 && $1 !~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/ {print $1}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -n 10


## Question 2 ##
echo -e "\n\n--- Percentage of IP vs Hostname Requests ---"
# Counting total requests and IP requests for July
total_july=$(wc -l < NASA_Jul95.log)
ip_july=$(grep -c "^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+" NASA_Jul95.log)
host_july=$((total_july - ip_july))

# Counting total requests and IP requests for August
total_aug=$(wc -l < NASA_Aug95.log)
ip_aug=$(grep -c "^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+" NASA_Aug95.log)
host_aug=$((total_aug - ip_aug))

# I am using awk because I am using a Windows machine and the bc command is not native to Windows.
ip_july_pct=$(awk "BEGIN {printf \"%.2f\", ($ip_july / $total_july) * 100}")
host_july_pct=$(awk "BEGIN {printf \"%.2f\", ($host_july / $total_july) * 100}")

ip_aug_pct=$(awk "BEGIN {printf \"%.2f\", ($ip_aug / $total_aug) * 100}")
host_aug_pct=$(awk "BEGIN {printf \"%.2f\", ($host_aug / $total_aug) * 100}")

echo "Distribution of requests in July 1995:"
echo "Total lines: $total_july"
echo "IP address requests: $ip_july ($ip_july_pct%)"
echo "Hostname requests: $host_july ($host_july_pct%)"

echo -e "\nDistribution of requests in August 1995:"
echo "Total lines: $total_aug"
echo "IP address requests: $ip_aug ($ip_aug_pct%)"
echo "Hostname requests: $host_aug ($host_aug_pct%)"


## Question 3 ##
echo -e "\n\n--- Top 10 Requests ---"
echo "Top 10 requests in July 1995:"
# I am using LC_ALL=C to resolve an error I was getting with the sort command.
awk '$9 != 404 {print $7}' NASA_Jul95.log | LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr | head -n 10
echo -e "\nTop 10 requests in August 1995:"
awk '$9 != 404 {print $7}' NASA_Aug95.log | LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr | head -n 10


## Question 4 ##
echo -e "\n\n--- Most Frequent Request Types ---"
echo "Top request types in July 1995:"
awk '{print $6}' NASA_Jul95.log | LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr | head -n 3
echo -e "\nTop request types in August 1995:"
awk '{print $6}' NASA_Aug95.log | LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr | head -n 3


## Question 5 ##
echo -e "\n\n--- Total 404 Errors ---"
echo "Total 404 errors in July 1995:"
awk '$9 == 404' NASA_Jul95.log | wc -l
echo -e "\nTotal 404 errors in August 1995:"
awk '$9 == 404' NASA_Aug95.log | wc -l


## Question 6 ##
echo -e "\n\n--- Percentage of Most Frequent Response Codes ---"
# Counting total codes for July and pulling the most frequent code
code_july=$(awk '{print $9}' NASA_Jul95.log | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
code_july_count=$(awk '{print $9}' NASA_Jul95.log | sort | uniq -c | sort -nr | head -n 1 | awk '{print $1}')

# Counting total codes for August and pulling the most frequent code
code_aug=$(awk '{print $9}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}')
code_aug_count=$(awk '{print $9}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -n 1 | awk '{print $1}')

echo "Distribution of request codes in July 1995:"
echo "Most frequent request code: $code_july"
echo "Percentage of responses with code $code_july: $(awk "BEGIN {printf \"%.2f\", ($code_july_count / $total_july) * 100}")%"

echo -e "\nDistribution of request codes in August 1995:"
echo "Most frequent request code: $code_aug"
echo "Percentage of responses with code $code_aug: $(awk "BEGIN {printf \"%.2f\", ($code_aug_count / $total_aug) * 100}")%"


## Question 7 ##
echo -e "\n\n--- Most Active Timeframes ---"
echo "Most active hours in July 1995:"
# Extract hour from timestamp and group into 1-hour blocks
awk '{split($4, time, ":"); hour=time[2]; printf "%02d:00-%02d:00\n", hour, (hour+1)%24}' NASA_Jul95.log | sort | uniq -c | sort -nr | head -n 5
echo "Least active hours in July 1995:"
awk '{split($4, time, ":"); hour=time[2]; printf "%02d:00-%02d:00\n", hour, (hour+1)%24}' NASA_Jul95.log | sort | uniq -c | sort -nr | tail -n 5

echo -e "\nMost active hours in August 1995:"
awk '{split($4, time, ":"); hour=time[2]; printf "%02d:00-%02d:00\n", hour, (hour+1)%24}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -n 5
echo "Least active hours in August 1995:"
awk '{split($4, time, ":"); hour=time[2]; printf "%02d:00-%02d:00\n", hour, (hour+1)%24}' NASA_Aug95.log | sort | uniq -c | sort -nr | tail -n 5


## Question 8 ##
echo -e "\n\n--- Largest and Average Response Sizes ---"
echo "Largest response size in July 1995:"
awk '{print $10}' NASA_Jul95.log | sort -nr | head -n 1 | awk '{printf "%d bytes\n", $1}'
echo "Average response size in July 1995:"
awk '{sum += $10} END {printf int(sum/NR) " bytes"}' NASA_Jul95.log

echo -e "\nLargest response size in August 1995:"
awk '{print $10}' NASA_Aug95.log | sort -nr | head -n 1 | awk '{printf "%d bytes\n", $1}'
echo "Average response size in August 1995:"
awk '{sum += $10} END {printf int(sum/NR) " bytes"}' NASA_Aug95.log


## Question 9 ##
echo -e "\n\n--- Outage Days ---"
echo "Checking for outage days in August logs..."

# Extracting dates from August logs
awk '{print $4}' NASA_Aug95.log | cut -d"/" -f1-2 | sort | uniq -c

# Finding last log on August 1 and first log on August 3
hurricane_begin=$(awk '{print $4}' NASA_Aug95.log | awk -F'/' '$1 == "[01"' | sort -r | head -n 1 | tr -d '[]')
hurricane_end=$(awk '{print $4}' NASA_Aug95.log | awk -F'/' '$1 == "[03"' | sort | head -n 1 | tr -d '[]')

# Extracting time components using awk
begin_hour=$(echo "$hurricane_begin" | awk -F'[:]' '{print $2}')
begin_min=$(echo "$hurricane_begin" | awk -F'[:]' '{print $3}')
end_hour=$(echo "$hurricane_end" | awk -F'[:]' '{print $2}')
end_min=$(echo "$hurricane_end" | awk -F'[:]' '{print $3}')

# Calculating total hours (including partial hours)
begin_total=$(awk "BEGIN {printf \"%.2f\", $begin_hour + ($begin_min/60)}")
end_total=$(awk "BEGIN {printf \"%.2f\", $end_hour + ($end_min/60)}")

# Adding 24 hours for the full day of August 2
total_hours=$(awk "BEGIN {printf \"%.2f\", (24 - $begin_total) + $end_total + 24}")

echo -e "\nThe outage began at $hurricane_begin and ended at $hurricane_end. The outage lasted for $total_hours hours."


## Question 10 ##
echo -e "\n\n--- Most Active Date Overall ---"
echo "Most active date in July 1995:"
awk '{split($4, time, ":"); day=time[1]; gsub("\\[", "", day); printf "%s\n", day}' NASA_Jul95.log | sort | uniq -c | sort -nr | head -n 1
echo -e "\nMost active date in August 1995:"
awk '{split($4, time, ":"); day=time[1]; gsub("\\[", "", day); printf "%s\n", day}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -n 1


## Question 11 ##
echo -e "\n\n--- Least Active Date Overall ---"
echo "Least active date in July 1995:"
awk 'NF >= 4 {split($4, time, ":"); day=time[1]; gsub("\\[", "", day); printf "%s\n", day}' NASA_Jul95.log | sort | uniq -c | sort -nr | tail -n 1
echo "Debugging empty lines:"
awk 'NF < 4 {print $0}' NASA_Jul95.log

echo -e "\nLeast active date in August 1995 (excluding August 2nd):"
awk '{split($4, time, ":"); day=time[1]; gsub("\\[", "", day); if (day != "02/Aug/1995") printf "%s\n", day}' NASA_Aug95.log | sort | uniq -c | sort -nr | tail -n 1