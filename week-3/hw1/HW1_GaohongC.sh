echo "---------"
echo "Problem 1"
echo "---------"

echo "Top 10 hosts (Jul95, non-404):"
awk '$9 != 404 {print $1}' NASA_Jul95.log | sort | uniq -c | sort -nr | head -10

echo ""
echo "Top 10 hosts (Aug95, non-404):"
awk '$9 != 404 {print $1}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -10

echo ""

echo "---------"
echo "Problem 2"
echo "---------"

echo "NASA_Jul95.log"

total=$(awk '{print $1}' "NASA_Jul95.log" | wc -l)
ips=$(awk '{print $1}' "NASA_Jul95.log" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)
hosts=$(awk '{print $1}' "NASA_Jul95.log" | grep -vE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)

percent_ips=$(echo "scale=2; $ips*100/$total" | bc)
percent_hosts=$(echo "scale=2; $hosts*100/$total" | bc)

echo "  Total Requests       : $total"
echo "  IP Requests          : $ips (${percent_ips}%)"
echo "  Hostname Requests    : $hosts (${percent_hosts}%)"
echo""

echo "NASA_Aug95.log"

total=$(awk '{print $1}' "NASA_Aug95.log" | wc -l)
ips=$(awk '{print $1}' "NASA_Aug95.log" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)
hosts=$(awk '{print $1}' "NASA_Aug95.log" | grep -vE '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)

percent_ips=$(echo "scale=2; $ips*100/$total" | bc)
percent_hosts=$(echo "scale=2; $hosts*100/$total" | bc)

echo "  Total Requests       : $total"
echo "  IP Requests          : $ips (${percent_ips}%)"
echo "  Hostname Requests    : $hosts (${percent_hosts}%)"
echo""

echo "---------"
echo "Problem 3"
echo "---------"

echo "NASA_Jul95.log"
awk '$9 != 404 {print $7}' "NASA_Jul95.log" | sort | uniq -c | sort -nr | head -10
echo ""

echo "NASA_Aug95.log"
awk '$9 != 404 {print $7}' "NASA_Aug95.log" | sort | uniq -c | sort -nr | head -10
echo ""

echo "---------"
echo "Problem 4"
echo "---------"

echo "NASA_Jul95.log"
awk -F\" '{print $2}' NASA_Jul95.log | awk '{print $1}' | sort | uniq -c | sort -rn
echo ""

echo "NASA_Jul95.log"
awk -F\" '{print $2}' NASA_Jul95.log | awk '{print $1}' | sort | uniq -c | sort -rn
echo ""

echo "---------"
echo "Problem 5"
echo "---------"

echo "NASA_Jul95.log"
awk '$9 == 404' NASA_Jul95.log | wc -l

echo ""
echo "NASA_Aug95.log "
awk '$9 == 404' NASA_Aug95.log | wc -l
echo ""

echo "---------"
echo "Problem 6"
echo "---------"

echo "NASA_Jul95.log"
total_responses=$(awk '{print $9}' NASA_Jul95.log | wc -l)
most_common=$(awk '{print $9}' NASA_Jul95.log | sort | uniq -c | sort -rn | head -1)
response_code=$(echo $most_common | awk '{print $2}')
count=$(echo $most_common | awk '{print $1}')
percentage=$(awk "BEGIN { printf \"%.2f\", ($count/$total_responses)*100 }")
echo "$response_code ($percentage%)"
echo ""

echo "NASA_Aug95.log"
total_responses=$(awk '{print $9}' NASA_Aug95.log | wc -l)
most_common=$(awk '{print $9}' NASA_Aug95.log | sort | uniq -c | sort -rn | head -1)
response_code=$(echo $most_common | awk '{print $2}')
count=$(echo $most_common | awk '{print $1}')
percentage=$(awk "BEGIN { printf \"%.2f\", ($count/$total_responses)*100 }")
echo "$response_code ($percentage%)"
echo ""

echo "---------"
echo "Problem 7"
echo "---------"

echo "NASA_Jul95.log"
awk -F: '{print $2}' NASA_Jul95.log | cut -c1-2 | sort | uniq -c | sort -n

echo ""
echo "NASA_Aug95.log"
awk -F: '{print $2}' NASA_Aug95.log | cut -c1-2 | sort | uniq -c | sort -n

echo ""

echo "---------"
echo "Problem 8"
echo "---------"

echo "NASA_Jul95.log"
awk '$10 ~ /^[0-9]+$/ {sum += $10; if ($10 > max) max=$10; count++} END {print "Max:", max, "Avg:", sum/count}' NASA_Jul95.log

echo ""
echo "NASA_Aug95.log"
awk '$10 ~ /^[0-9]+$/ {sum += $10; if ($10 > max) max=$10; count++} END {print "Max:", max, "Avg:", sum/count}' NASA_Aug95.log
echo ""

echo "---------"
echo "Problem 9"
echo "---------"

echo "NASA_Jul95.log"
if [[ "NASA_Jul95.log" == *"Aug95"* ]]; then
  echo "Detecting data outage in August log:"
  awk '{print $4}' "NASA_Jul95.log" | cut -d: -f1 | sed 's/\[//' | uniq -c | sort
  echo "Look for gap in date counts to identify outage manually or enhance with diff logic."
fi
echo ""

echo "NASA_Aug95.log"
if [[ "NASA_Aug95.log" == *"Aug95"* ]]; then
  echo "Detecting data outage in August log:"
  awk '{print $4}' "NASA_Aug95.log" | cut -d: -f1 | sed 's/\[//' | uniq -c | sort
  echo "Look for gap in date counts to identify outage manually or enhance with diff logic."
fi
echo ""

echo "---------"
echo "Problem 10"
echo "---------"

echo "NASA_Jul95.log"
awk '{print $4}' "NASA_Jul95.log" | cut -d: -f1 | sed 's/\[//' | sort | uniq -c | sort -nr | head -1
echo ""

echo "NASA_Aug95.log"
awk '{print $4}' "NASA_Aug95.log" | cut -d: -f1 | sed 's/\[//' | sort | uniq -c | sort -nr | head -1
echo ""

echo "---------"
echo "Problem 11"
echo "---------"

echo "NASA_Jul95.log"
awk '{print $4}' "NASA_Jul95.log" | cut -d: -f1 | sed 's/\[//' | sort | uniq -c | awk '$1 > 100' | sort -n | head -1

echo "NASA_Aug95.log"
awk '{print $4}' "NASA_Aug95.log" | cut -d: -f1 | sed 's/\[//' | sort | uniq -c | awk '$1 > 100' | sort -n | head -1
