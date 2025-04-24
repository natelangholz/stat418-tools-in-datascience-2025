
for file in "$@"
do

   echo "Processing $file..."

#Question 1

   echo "Question 1: "
   awk '$9 != 404 {print $1}' $file | sort | uniq -c | sort -nr | head -10

#Question 2

   echo "Question 2: "
   file="$1"

   total=$(wc -l < "$file")
   num_ip=$(awk '{print $1}' "$file" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]$' | wc -l)

   percent_ip=$(awk -v ip="$num_ip" -v total="$total" 'BEGIN {printf "%.2f", (100 * ip / total) }')
   percent_host=$(awk -v ip="$percent_ip" 'BEGIN {printf "%.2f", (100 - ip) }')

   echo "From file: $file"
   echo "Total Requests: $total"
   echo "IP-based Requests: $num_ip ($percent_ip%)"
   echo "Hostname-Based Requests: $((total-num_ip)) ($percent_host%)"

#Question 3

   echo "Question 3: "

   echo "Top 10 requested resources (non-404):"
   awk '$9 != 404 {print $7}' "$file" | sort | uniq -c | sort -nr | head -10


done

#Question 4 

   echo "Question 4: "

   awk '{gsub(/"/, "", $6); print $6}' "$file" | sort | uniq -c | sort -nr

#Question 5

   echo "Question 5: "

   num_404=$(awk '$9 == 404' "$file" | wc -l)
   echo "404 Errors: $num_404"

# Question 6

   echo "Question 6: "
   most_freq=$(awk '{print $9}' "$file" | sort | uniq -c | sort -nr |head -1)

   count=$(echo "$most_freq" | awk '{print $1}')
   code=$(echo "$most_freq" | awk '{print $2}')

   total=$(awk '{print $9}' "$file" |wc -l)

   freq_percent=$(awk "BEGIN { printf \"%.2f\", ($count / $total) * 100}")

   echo "Most frequent response code: $code"
   echo "Count: $count out of $total"
   echo "Percentage: $freq_percent%"

# Question 7

   echo "Question 7:"
   hour_counts=$(awk '{gsub(/\[/, "", $4); split($4, a, ":"); print a[2]}' "$file" | sort | uniq -c)

   most_active=$(echo "$hour_counts" | sort -nr | head -1)
   least_active=$(echo "$hour_counts" | sort -n | head -1)

   most_count=$(echo "$most_active" | awk '{print $1}')
   most_hour=$(echo "$most_active" | awk '{print $2}')

   least_count=$(echo "$least_active" | awk '{print $1}')
   least_hours=$(echo "$least_active" | awk '{print $2}')

   echo "Most active hour: $most_hour with $most_count requests"
   echo "Least active hour: $least_hour with $least_count requests"

   echo
   echo "Requests per hour:"
   echo "$hour_counts" | sort -k2n


   echo "Question 8:"
   awk '$10 ~ /^[0-9]+$/ { sum += $10; if ($10 > max) max = $10; count++ } END {
    printf "Max response size: %d bytes\n", max;
    printf "Average response size: %.2f bytes\n", sum / count;
   }' "$file"

#Question 9



#Question 10

echo "Question 10:"

most_active_date=$(grep -oP '\[\d{2}/\w{3}/1995' "$file" | sed 's/\[//' | sort | uniq -c | sort -nr | head -1)
count=$(echo "$most_active_date" | awk '{print $1}')
date=$(echo "$most_active_date" | awk '{print $2}')
echo "In file $file, the date that saw the most activity was $date with $count requests."

#Question 11

echo "Question 11:"

# Extract and count requests per date
date_counts=$(grep -oP '\[\d{2}/\w{3}/1995' "$file" | sed 's/\[//' | sort | uniq -c)

# Filter out empty lines and find the minimum (non-zero) activity date
least_active_date=$(echo "$date_counts" | sort -n | head -1)

# Parse the count and date
count=$(echo "$least_active_date" | awk '{print $1}')
date=$(echo "$least_active_date" | awk '{print $2}')

echo "In file $file, the date with the least activity (excluding outages) was $date with $count requests."
