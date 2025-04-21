#!/bin/bash

export LC_ALL=C

cd /Users/Sam/Documents/UCLA/STATS_418/hw1

for file in "$@"; do
    echo "Analyzing $file"
    echo "------------------------------------------------"

    echo "1. List the top 10 web sites from which requests came (non-404 status)."
    awk '$9 != 404 {print $1}' "$file" | sort | uniq -c | sort -nr | head -10
    echo ""

    echo "2. What percentage of host requests came from IP vs hostname?"
    total=$(wc -l < "$file")
    ip_count=$(awk '$1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/' "$file" | wc -l)
    host_count=$((total - ip_count))
    ip_percent=$(awk "BEGIN{printf \"%.2f\", ($ip_count/$total)*100}")
    host_percent=$(awk "BEGIN{printf \"%.2f\", ($host_count/$total)*100}")
    echo "IP: $ip_percent% | Hostname: $host_percent%"
    echo ""

    echo "3. List the top 10 requests (non-404 status)."
    awk '$9 != 404 {print $7}' "$file" | sort | uniq -c | sort -rn | head -10
    echo ""

    echo "4. List the most frequent request types."
    awk -F\" '{print $2}' "$file" | awk '{print $1}' | sort | uniq -c | sort -rn
    echo ""

    echo "5. How many 404 errors were reported in the log?"
    awk '$9 == 404' "$file" | wc -l
    echo ""

    echo "6. What is the most frequent response code and what percentage of responses did this account for?"
    total_responses=$(awk '{print $9}' "$file" | wc -l)
    most_common_line=$(awk '{print $9}' "$file" | sort | uniq -c | sort -rn | head -1)
    count=$(echo "$most_common_line" | awk '{print $1}')
    response_code=$(echo "$most_common_line" | awk '{print $2}')
    percentage=$(awk "BEGIN {printf \"%.2f\", ($count/$total_responses)*100}")
    echo "$response_code ($percentage%)"
    echo ""

    echo "7. What time of day is the site active? When is it quiet?"
    echo "Requests per hour:"
    awk -F: '{print $2}' "$file" | cut -c 2-3 | sort | uniq -c | sort -n
    echo ""

    echo "8. What is the biggest overall response (in bytes) and what is the average?"
    awk '$10 ~ /^[0-9]+$/ {sum+=$10; if ($10>max) max=$10; count++} END {printf "Max: %d, Avg: %.2f\n", max, sum/count}' "$file"
    echo ""

    echo "9. Dates without log data (only for August):"
    if [[ "$file" == *"Aug95"* ]]; then
        echo "Dates without log data:"
        awk '{print $4}' "$file" | cut -d: -f1 | sed 's/\[//' | sort | uniq > existing_dates.txt
        for day in {01..31}; do
            date="0$day/Aug/1995"
            date=${date: -11}  # Trim to exact format
            if ! grep -q "$date" existing_dates.txt; then
                echo "$date"
            fi
        done
        rm existing_dates.txt
    else
        echo "→ Not applicable for July file."
    fi
    echo ""

    echo "10. Which date saw the most activity overall?"
    awk '{print $4}' "$file" | cut -d: -f1 | sed 's/\[//' | sort | uniq -c | sort -nr | head -1
    echo ""

    echo "11. Excluding outage dates, which date saw the least activity?"
    awk '{print $4}' "$file" | cut -d: -f1 | sed 's/\[//' | sort | uniq -c > all_dates.txt

    if [[ "$file" == *"Aug95"* ]]; then
        grep -v -F -f <(awk '{print $4}' "$file" | cut -d: -f1 | sed 's/\[//' | sort | uniq -c | awk '$1 < 1000 {print $2}') all_dates.txt | sort -n | head -1
    else
        sort -n all_dates.txt | head -1
    fi

    rm all_dates.txt
    echo ""

    echo "==========================================================="
    echo ""
done

