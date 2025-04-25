curl -s https://atlas.cs.brown.edu/data/web-logs/NASA_Jul95.log > NASA_Jul95.log
curl -s https://atlas.cs.brown.edu/data/web-logs/NASA_Aug95.log > NASA_Aug95.log

files=("NASA_Jul95.log" "NASA_Aug95.log")

for FILE in "${files[@]}"; do
	echo
	echo "==================== Processing $FILE ===================="

# 1: Top 10 Websites (Non 404 Status) 
	echo "1. Top 10 hostnames/I (non-404):"
	awk '$9 != 404 {count[$1]++} END { for (ip in count) print count[ip], ip }' "$FILE" | sort -nr | head -10
	echo

# 2: IP vs Hostname %
	echo "2. Percentage of requests from IP vs Hostname:"
	total=$(awk '{print $1}' "$FILE" | wc -l)
	total_IP=$(awk '{print $1}' "$FILE" | awk '/^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/ {count++} END {print count}')
	IP_Pct=$(awk "BEGIN { printf \"%.2f\", ($total_IP/$total)*100 }")
	Host_Pct=$(awk "BEGIN { printf \"%.2f\", 100 - $IP_Pct }")
	echo "IP: $IP_Pct% | Host: $Host_Pct%"
	echo

# 3: Top 10 Requests (Non 404 Status)
	echo "3. Top 10 Requests (Non 404 Status):"
	awk '$(NF-1) != 404' "$FILE" | awk -F\" '{print $2}' | LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr | head -10
	echo

# 4: List of most frequent request types (Non 404 Status)
	echo "4. List of most frequent request types (Non 404 Status):"
	awk '$(NF-1) != 404' "$FILE" | awk -F\" '{print $1}' | LC_ALL=C sort | uniq -c | LC_ALL=C sort -nr | head -10
	echo

# 5: The count of 404 errors reported in this log:
	echo "5. Count of 404 errors:"
	awk '$(NF-1) == 404 {count++} END {print count}' "$FILE"
	echo

# 6: The most frequent response code & percentage of responses it accounts for
	echo "6. Most frequent response code & pct:"
	responses_ct=$(awk '{print $(NF-1)}' "$FILE" | wc -l)

	awk -v total="$responses_ct" '
	{
	    count[$(NF-1)]++
	}
	END {
    	if (total == 0) {
        	print "No responses to process."
        	exit
    	}
    	for (code in count) {
        	if (count[code] > max) {
            	max = count[code]
            	max_code = code
        	}
    	}
    	percent = (max * 100.0) / total
    	printf "Code: %s | Count: %d | Percentage: %.2f%%\n", max_code, max, percent
	}' "$FILE"
	echo

# 7: What time of day is the site active & when is it quiet?
	echo "7. Active & quiet site times:"
	awk -F: '{split($2, h, ":"); print h[1]}' "$FILE" | sort | uniq -c | sort -nr | head -1 | awk '{print "Peak hour: " $2 ":00 - Requests: " $1}'
	awk -F: '{split($2, h, ":"); print h[1]}' "$FILE" | sort | uniq -c | sort -n | head -1 | awk '{print "Quiet hour: " $2 ":00 - Requests: " $1}'
	echo

# 8: the max response & average response (in bytes)
	echo "8. What is the largest response, and the average response:"
	awk '$NF ~ /^[0-9]+$/ { if ($NF > max) max = $NF } END { print "Max: " max " bytes" }' "$FILE"
	awk '$NF ~ /^[0-9]+$/ { sum += $NF; count++ } END { avg = (count > 0) ? sum / count : 0; printf "Avg: %.0f bytes\n", avg }' "$FILE"
	echo

# 9: Times & dates data was not collected during hurricane, & outage duration
# 9: Times & dates data was not collected during hurricane, & outage duration
if [[ "$FILE" == "NASA_Aug95.log" ]]; then
    echo "9. Data collection outage (August only):"

    # Get the dates present in the log file (extract month and day)
    LC_ALL=C awk '{gsub(/\[/, "", $4); split($4, d, "/"); print d[1] "/" d[2] "/1995"}' "$FILE" | sort | uniq > dates_present.txt

    # Create a list of expected dates (01 to 31 for August 1995)
    seq -w 01 31 | awk '{print "08/" $1 "/1995"}' | sort > expected_dates.txt

    # Compare the two lists to find missing dates
    comm -23 expected_dates.txt dates_present.txt > missing_dates.txt

    # Debugging: Check the contents of dates_present.txt
    echo "Dates present in the log file (from the log):"
    cat dates_present.txt

    # Debugging: Check the contents of expected_dates.txt
    echo "Expected dates for August 1995:"
    cat expected_dates.txt

    # Debugging: Check the contents of missing_dates.txt
    echo "Missing dates (calculated):"
    cat missing_dates.txt

    # Check if there are missing dates
    if [[ -s missing_dates.txt ]]; then
        echo "Missing dates:"
        cat missing_dates.txt
        # Count the number of missing dates (outage duration)
        OUTAGE_DAYS=$(wc -l < missing_dates.txt)
        echo "Outage duration: $OUTAGE_DAYS day(s)"
    else
        echo "No missing dates. Data was collected on all days in August."
    fi

    # Clean up temporary files
    rm -f dates_present.txt expected_dates.txt missing_dates.txt
    echo
else
    echo "9. DOES NOT APPLY, Not the file of interest."
fi



# 10: Busiest Day
	echo "10. What day saw the most activity:"
	LC_ALL=C awk '{gsub(/\[/, "", $4); split($4, d, "/"); print d[1] "/" d[2] "/1995"}' "$FILE" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}'
	echo

# 11: Least active day (excluding outage dates)
	echo "11. Least active day (excluding outage dates):"
	if [[ "$FILE" == "NASA_Jul95.log" ]]; then
    		LC_ALL=C awk '{
        	gsub(/\[/, "", $4)
        	if ($4 ~ /^[0-9]{2}\/[A-Za-z]{3}\/1995/) {
            		split($4, d, "/")
            		print d[1] "/" d[2] "/1995"
        	}
    	}' "$FILE" \
    	| sort | uniq -c | sort -n | head -1 | awk '{print $2}'
	else
    		LC_ALL=C awk '{
        	gsub(/\[/, "", $4)
        	if ($4 ~ /^[0-9]{2}\/[A-Za-z]{3}\/1995/) {
            		split($4, d, "/")
            		print d[1] "/" d[2] "/1995"
        	}
    	}' "$FILE" \
    	| grep -v -F -f missing_dates.txt \
    	| sort | uniq -c | sort -n | head -1 | awk '{print $2}'
	fi
	echo

done
