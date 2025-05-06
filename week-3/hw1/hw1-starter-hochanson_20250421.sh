#!/bin/bash
export LC_ALL=C

##############################################################
### problem statements
#the following fetch both NASA log files from the corresponding urls and write. Write them to your local hw1 directory and create a NEW .sh file that can be run on files named:
# NASA_Jul95.log
# NASA_Aug95.log
# sample output: 
# awk -F ' ' '{print $1, $4, $5, $6, $7, $8, $9, $10}' will print the first 10 fields of the log file.
#  i.e. {$1=van15422.direct.ca, $2=-, $3=- $4=[01/Aug/1995:00:07:11 $5=-0400] $6="GET $7=/software/winvn/bluemarb.gif $8=HTTP/1.0" $9=200 $10=104441}
#awk '{print $0}' nasa_jul95.log
##############################################################

### How to run this script ###
# 1. Save the script as hw1-starter.sh
# 2. Make it executable: chmod +x hw1-starter.sh
# 3. Run the script: ./hw1-starter.sh <filename>
# 4. Provide the filename as an argument, e.g., ./hw1-starter.sh NASA_Jul95.log

filename="NASA_Aug95.log"

###################
## preprocessing ##
###################

if [ $# -eq 0 ]; then
    echo "Usage: $0 <filename>"
    echo "please provide the filename to download i.e.) NASA_Jul95.log or NASA_Aug95.log"
    exit 1
fi

#check if the files exist
if [ ! -e "$1" ]; then
    # Download the files if they don't exist
    curl -s "https://atlas.cs.brown.edu/data/web-logs/$1" > "$1"
else
    echo "Files already exist. Skipping download."
fi

file_non404=$(echo "$1" | sed -e 's/.log/_non404.tmp/g')
file_404=$(echo "$1"| sed -e 's/.log/_404.tmp/g')

echo "Temporary files: $file_non404, $file_404"

if [ -e "$file_non404" ]; then
    echo "Temporary files already exist. Skipping filtering."
else
    # filter non-404 requests only
    awk '$9 != 404' "$1" > "$file_non404"
fi

if [ -e "$file_404" ]; then
    echo "Temporary files already exist. Skipping filtering."
else
    # filter 404 requests only
    awk '$9 == 404' "$1" > "$file_404"
fi 

sleep 5s

################## solution to problems ##################
# 1. List the top 10 web sites from which requests came (non-404 status).
p1=$(awk '{print $1 $6}' $file_non404 | sort | uniq -c | sort -nr | head -n 10)
printf "1. List the top 10 web sites from which requests came (non-400 status).\n"
printf "result:\n%s\n" "$p1"

# 2. What percentage of host requests came from IP vs hostname?
total=$(wc -l < $1)
ip=$(awk '{print $1}' $1 | grep -E '^([0-9]+\.){3}[0-9]+$' | wc -l)
hostname=$((total - ip))

printf "2. What percentage of host requests came from IP vs hostname?.\n"
printf "result:\n"
awk -v "ip=$ip" -v "hostname=$hostname" -v "total=$total" \
    'BEGIN { 
        printf "IP: %.2f%%\n", (ip / total) * 100
        printf "Hostname: %.2f%%\n", (hostname / total) * 100 
    }'

#3. List the top 10 requests (non-404 status)
p3=$(awk '{print $7}' $file_non404 | sort | uniq -c | sort -rn | head -n 10)
printf "3. List the top 10 requests (non-404 status).\n"
printf "result:\n%s\n" "$p3"

#4. List the most frequent request types?
p4=$(echo $p3 | head -n 1 | awk '{print $2}')
printf "4. List the most frequent request types.\n"
printf "result:\n%s\n" "$p4"

#5. How many 404 errors were reported in the log? 
p5=$(cat $file_404 | wc -l)
printf "5. How many 404 errors were reported in the log?\n"
printf "result:\n%s\n" "$p5"

#6. What is the most frequent response code and what percentage of reponses did this account for? 
p6_top_code=$(cat $1 | awk '{print $9}' | sort | uniq -c | sort -nr | head -n 1)
printf "6. What is the most frequent response code and what percentage of reponses did this account for?\n"
p6_code=$(echo $p6_top_code | awk '{print $2}')
p6_code_count=$(echo $p6_top_code | awk '{print $1}')
awk -v "code=$p6_code" -v "cnt=$p6_code_count" -v "total=$total" \
    'BEGIN {
        printf "result:\n frequent_code:%s\n", code
        printf " percent: %.2f%%\n", ( cnt / total) * 100 
    }'

#7. What time of day is the site active? When is it quiet?
printf "7. What time of day is the site active? When is it quiet?\n"
printf "result:\n"
awk '{
    # Extract hour from timestamp
    if ($4 ~ /\[([0-9]{2})\/Aug\/1995:([0-9]{2}):/) {
        hour = substr($4, 14, 2)
        count[hour]++
    }
}
END {
    max_hour = 0
    min_hour = 24
    for (h in count) {
        if (count[h] > count[max_hour]) {
            max_hour = h
        }
        if (count[h] < count[min_hour]) {
            min_hour = h
        }
    }
    printf "Most active hour: %s\n", max_hour
    printf "Quietest hour: %s\n", min_hour
}' $1

# #8. What is the biggest overall response (in bytes) and what is the average?
printf "8. What is the biggest overall response (in bytes) and what is the average?\n"
printf "result:\n"
awk '{
    if($10 ~ /^[0-9]+$/) {
        sum += $10
        if($10 > max) max = $10
    }
} 
END {
    printf "Max: %d bytes\n", max
    printf "Average: %.2f bytes\n", sum/NR
}' $1

#9.There was a hurricane during August where there was no data collected. Identify the times and dates when data was not collected for August. How long was the outage?
printf "9. Identify the times and dates when data was not collected for August. How long was the outage?\n"
# filename="NASA_Aug95.log"
awk 'BEGIN {
    prev_timestamp = ""
    in_outage = 0
    outage_start = ""
}
{
    # Extract timestamp from log entry [DD/MM/YYYY:HH:MM:SS
    if ($4 ~ /\[([0-9]{2})\/Aug\/1995/) {
        # Clean up timestamp
        current = $4
        gsub(/[\[\]]/, "", current)
        
        if (prev_timestamp != "") {
            # Split timestamps into components
            split(current, c, "[/: ]")
            split(prev_timestamp, p, "[/: ]")
            
            # Calculate seconds difference
            curr_seconds = (c[1] * 24 * 3600) + (c[4] * 3600) + (c[5] * 60) + c[6]
            prev_seconds = (p[1] * 24 * 3600) + (p[4] * 3600) + (p[5] * 60) + p[6]
            diff = curr_seconds - prev_seconds
            
            # Detect outage (gap > 1 hour)
            if (diff > 3600 && !in_outage) {
                printf "Outage Start: %s\n", prev_timestamp
                outage_start_seconds = prev_seconds
                in_outage = 1
            } 
            else if (diff <= 3600 && in_outage) {
                printf "Outage End: %s\n", current
                printf "Duration: %.2f hours\n\n", (curr_seconds - outage_start_seconds)/3600
                in_outage = 0
            }
        }
        prev_timestamp = current
    }
}
END {
    if (in_outage) {
        printf "Note: Outage was still ongoing at end of log\n"
    }
}' $1

#10. Which date saw the most activity overall?
printf "10. Which date saw the most activity overall?\n"
active=$(awk '{print $4}' $1 | cut -d':' -f1  | sort | uniq -c | sort -nr | head -n 1 | awk '{print $2}' | sed -e 's/\[//g') 
printf "result:\n%s\n" "$active"

#11. Excluding the outage dates which date saw the least amount of activity?
printf "11. Least active date (excluding outage dates):\n"
awk '
BEGIN {
    # Initialize dates array
    for(i=1; i<=31; i++) {
        dates[sprintf("%02d/Aug/1995", i)] = 0
    }
}
{
    # Extract date from timestamp
    if ($4 ~ /\[([0-9]{2})\/Aug\/1995/) {
        split($4, parts, "[:[]")
        dates[parts[2]]++
    }
}
END {
    min_count = 999999
    min_date = ""
    
    # Find minimum excluding outage date (02/Aug/1995)
    for (date in dates) {
        if (date != "02/Aug/1995" && dates[date] > 0 && dates[date] < min_count) {
            min_count = dates[date]
            min_date = date
        }
    }
    printf "Date: %s\nRequests: %d\n", min_date, min_count
}' $1