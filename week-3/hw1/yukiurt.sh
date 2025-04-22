for file in "$@"
do
    #Print Which file is open
    echo "-------------------------------------"
    echo "For file: $file"
    echo "-------------------------------------"
    
    # Q1. Top 10 websites which requests came from
    echo 'Q1. Top 10 webstites requests are from'
    awk '$9 != 404 {print $1}' "$file" | sort | uniq -c | sort -nr | head -10

    # Q2. Percentage of host requests that came from IP vs hostname?
    echo 'Q2. Percentage of host requests that came from IP vs hostname'
    total=$(awk '{print $1}' "$file" | wc -l )
    num_ip=$(awk '{print $1}' "$file" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l )
    echo "scale=2; 100 * $num_ip / $total" |bc

    # Q3. Top 10 requests
    echo 'Q3. Top 10 requests made are'
    awk '$9 != 404 {print $7}' "$file" | sort | uniq -c | sort -nr | head -10

    # Q4. Most frequent request types
    echo 'Q4. Most frequent requests are'
    awk '$9 != 404 { gsub(/"/, "", $6); print $6 }' "$file" | sort | uniq -c | sort -nr

    # Q5. Number of 404 errors
    echo 'Q5. Number of 404 errors are'
    awk '$9 == 404' "$file" | wc -l

    # Q6. Most frequent response code and percentage
    echo 'Q6. Frequent response code and percentage'
    total=$(awk '{print $9}' "$file" | wc -l )
    awk '{print $9}' "$file" | sort | uniq -c | sort -nr | head -1 | while read count code; do
        echo "Most frequent: $code ($count requests)"
        echo "scale=2; 100 * $count / $total" | bc
    done

    # Q7. When is it active and when is it quiet
    echo 'Q7. Time of day when it is active, and when it is quiet'    
    awk -F'[' '{split($2, t, ":"); if (length(t[2]) == 2) print t[2]}' "$file" \
    | sort | uniq -c | awk '{printf "%02d:00 - %02d:59 => %d requests\n", $2, $2, $1}'

    echo 'The quiet hours for July are around 2:00 - 6:59, and the active hours are 10:00 - 16:59'
    echo 'The quiet hours for August is around 2:00 - 6:59, and the active hours are 12:00 - 15:59'

    # Q8. biggest overall response in bytes, and what is the average
    echo 'Q8. Biggest overall response, and the average bytes'
    awk '$10 ~ /^[0-9]+$/ {sum += $10; if ($10 > max) max = $10} END {print "Max:", max, "Avg:", sum/NR}' "$file"

    if [[ "$file" == *"Aug95.log" ]]; then
        
        # Q9. Identify the date when data was not collected for August
        echo 'Q9. Date when data was not collected'
        comm -23 <(
            for d in $(seq -w 1 31); do echo "$d/Aug/1995"; done | sort
        ) <(
            awk -F\[ '{print $2}' "$file" | cut -d: -f1 | sort | uniq
        )

        # Q10. Which date saw the most acitivity overall
        echo 'Q10. Most active date'
        awk -F\[ '{print $2}' "$file" | cut -d: -f1 | sort | uniq -c | sort -nr | head -1

        # Q11. Excluding the outage date, which day had the least amount of activity
        echo 'Q11. Least active date, excluding the outage date'
        awk -F\[ '{print $2}' "$file" | cut -d: -f1 | sort | uniq -c | sort -n | head -1
    fi

done