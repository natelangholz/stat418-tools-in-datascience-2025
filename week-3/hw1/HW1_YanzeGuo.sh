#!/bin/bash
# HW1 - Yanze Guo

july="NASA_Jul95.log"
aug="NASA_Aug95.log"

echo "========== Q1 =========="
echo "--- July ---"
awk '$9 != 404 {print $1}' $july | sort | uniq -c | sort -nr | head -10
echo "--- August ---"
awk '$9 != 404 {print $1}' $aug | sort | uniq -c | sort -nr | head -10

echo "\n========== Q2 =========="
for file in $july $aug; do
  echo "--- $(basename $file .log) ---"
  total=$(awk '{print $1}' $file | wc -l)
  ips=$(awk '{print $1}' $file | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)
  hostnames=$((total - ips))
  ip_percent=$(echo "scale=2; 100*$ips/$total" | bc)
  host_percent=$(echo "scale=2; 100*$hostnames/$total" | bc)
  echo "IPs: $ip_percent% ($ips), Hostnames: $host_percent% ($hostnames)"
done

echo "\n========== Q3 =========="
for file in $july $aug; do
  echo "--- $(basename $file .log) ---"
  awk '$9 != 404 {print $7}' $file | sort | uniq -c | sort -nr | head -10
done

echo "\n========== Q4 =========="
for file in $july $aug; do
  echo "--- $(basename $file .log) ---"
  awk '{print $6}' $file | tr -d '"' | grep -E '^[A-Z]+$' | sort | uniq -c | sort -nr
done

echo "\n========== Q5 =========="
for file in $july $aug; do
  echo "--- $(basename $file .log) ---"
  awk '$9 == 404' $file | wc -l
done

echo "\n========== Q6 =========="
for file in $july $aug; do
  echo "--- $(basename $file .log) ---"
  mf_rc=$(awk '{print $9}' $file | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')
  code_count=$(awk -v code="$mf_rc" '$9 == code' $file | wc -l)
  total_resp=$(wc -l < $file)
  resp_percent=$(echo "scale=2; 100*$code_count/$total_resp" | bc)
  echo "Code: $mf_rc | $resp_percent%"
done

echo "\n========== Q7 =========="
for file in $july $aug; do
  echo "--- $(basename $file .log) ---"
  awk -F: '{print $2}' $file | sort | uniq -c | sort -nr
done

echo "\n========== Q8 =========="
for file in $july $aug; do
  echo "--- $(basename $file .log) ---"
  awk '$10 ~ /^[0-9]+$/ {sum += $10; if ($10 > max) max = $10} END {print "Max:", max; print "Average:", sum / NR}' $file
done

echo "========== Q9 =========="
if [[ "$aug" == *"Aug95"* ]]; then
  echo "Detecting data outage in August log:"
  awk '{{print $4}}' "$aug" | cut -d: -f1 | sed 's/\\[//' | sort | uniq -c
  echo "→ Look for suspicious drop in count to identify outage period."
fi

echo "\n========== Q10 =========="
for file in $july $aug; do
  echo "--- $(basename $file .log) ---"
  awk '{print substr($4, 2, 11)}' $file | sort | uniq -c | sort -nr | head -1
done

echo "\n========== Q11 =========="
echo "--- July ---"
awk '{print substr($4, 2, 11)}' $july | sort | uniq -c | sort -n | head -1

echo "--- August ---"
awk '{print substr($4, 2, 11)}' $aug | grep -vE '21/Aug/1995|22/Aug/1995|23/Aug/1995|24/Aug/1995|25/Aug/1995|26/Aug/1995' | sort | uniq -c | sort -n | head -1
