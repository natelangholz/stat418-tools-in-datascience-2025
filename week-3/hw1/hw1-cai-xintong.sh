echo 'STAT-418-hw1'
echo 'Name: Xintong Cai'


echo "1. List the top 10 web sites from which requests came (non-404 status) for NASA_Jul95:"
echo 'For the NASA_Jul95'
awk '$9 != 404 { print $1 }' NASA_Jul95.log | sort | uniq -c | sort -rn | head
echo -e "\nFor NASA_Aug95.log:"
awk '$9 != 404 { print $1 }' NASA_Aug95.log | sort | uniq -c | sort -rn | head
echo ""


echo '2.What percentage of host requests came from IP vs hostname?'
echo -e "\nFor NASA_Jul95.log:"
total=$(awk '{print $1}' NASA_Jul95.log | wc -l)
ip_count=$(awk '{print $1}' NASA_Jul95.log | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)
# Calculate hostname-based requests
hostname_count=$((total - ip_count))

ip_pct=$(awk -v ip="$ip_count" -v total="$total" 'BEGIN { printf "%.2f", (ip / total) * 100 }')
hostname_pct=$(awk -v hn="$hostname_count" -v total="$total" 'BEGIN { printf "%.2f", (hn / total) * 100 }')


echo "Percentage from IP addresses: $ip_pct%"
echo "Percentage from hostnames: $hostname_pct%"
echo ""

echo -e "\nFor NASA_Aug95.log:"

total=$(awk '{print $1}' NASA_Aug95.log | wc -l)
ip_count=$(awk '{print $1}' NASA_Aug95.log | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)
# Calculate hostname-based requests
hostname_count=$((total - ip_count))

ip_pct=$(awk -v ip="$ip_count" -v total="$total" 'BEGIN { printf "%.2f", (ip / total) * 100 }')
hostname_pct=$(awk -v hn="$hostname_count" -v total="$total" 'BEGIN { printf "%.2f", (hn / total) * 100 }')


echo "Percentage from IP addresses: $ip_pct%"
echo "Percentage from hostnames: $hostname_pct%"
echo ""


echo '3.List the top 10 requests (non-404 status)'
echo -e "For NASA_Jul95.log:"
awk '$9 != 404 {print $6, $7}' NASA_Jul95.log | grep '^[[:print:]]*$' | tr -d '"' | sort | uniq -c | sort -nr | head
echo -e "\nFor NASA_Aug95.log:"
awk '$9 != 404 {print $6, $7}' NASA_Aug95.log | grep '^[[:print:]]*$' | tr -d '"' | sort | uniq -c | sort -nr | head
echo ""




echo '4. List the most frequent request types'
echo -e "For NASA_Jul95.log:"
awk '$9 != 404 {print $6}' NASA_Jul95.log | grep '^[[:print:]]*$' | tr -d '"' | sort | uniq -c | sort -nr | head -5
echo -e "\nFor NASA_Aug95.log:"
awk '$9 != 404 {print $6}' NASA_Aug95.log | grep '^[[:print:]]*$' | tr -d '"' | sort | uniq -c | sort -nr | head -5
echo 'The GET request is the most frequent request type in the log.'
echo ""



echo '5. How many 404 errors were reported in the log?'
echo -e "For NASA_Jul95.log:"
counting=$(awk '$9 = 404 ' NASA_JUL95.log | wc -l)
echo "The 404 errors happened: $counting times"
echo -e "\nFor NASA_Aug95.log:"
counting=$(awk '$9 = 404 ' NASA_Aug95.log | wc -l)
echo "The 404 errors happened: $counting times"
echo ""


echo '6.What is the most frequent response code and what percentage of reponses did this account for?'
echo -e "For NASA_Jul95.log:"
awk '{print $9}' NASA_Jul95.log | sort | uniq -c | sort -nr | head -1
awk '{
	if ($9 == 200) {
		common++
		total++
	} else {
		total++
	}
} END {
	print "For NASA_Jul95.log, the most error was error 200, which accounts for", common/total*100, "% of responses."
}' NASA_Jul95.log

echo -e "\nFor NASA_Aug95.log:"
awk '{print $9}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -1
awk '{
	if ($9 == 200) {
		common++
		total++
	} else {
		total++
	}
} END {
	print "The most common error in NASA_Aug95.log was error 200, making up", common/total*100, "% of responses."
}' NASA_Aug95.log

echo ""



echo '7. What time of day is the site active? When is it quiet?'
# Extract hour from timestamp field and count occurrences

LC_ALL=C awk -F'[:[]' '{print $3}' NASA_JUL95.log | sort | uniq -c | sort -nr | head -3
echo "The site is active around 14 in the afternoon and quite in 5 am and 4 am in the morning, which follows people's living habits."
echo ""
echo -e "For NASA_Aug95.log:"
LC_ALL=C awk -F'[:[]' '{print $3}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -3
echo "The site is active around 15 o'clock in the afternoon and quite after midnight. The most quiet moment is around 4:00 in the morning. "
echo ""

echo "8. What is the biggest overall response (in bytes) and what is the average?"

echo -e "For NASA_Jul95.log:"
awk '$10 ~ /^[0-9]+$/ {sum += $10; if ($10 > max) max = $10; count++} END {printf "Max: %d bytes\nAverage: %.2f bytes\n", max, sum/count}' NASA_Jul95.log
echo -e "\nFor NASA_Aug95.log:"
awk '$10 ~ /^[0-9]+$/ {sum += $10; if ($10 > max) max = $10; count++} END {printf "Max: %d bytes\nAverage: %.2f bytes\n", max, sum/count}' NASA_Aug95.log


