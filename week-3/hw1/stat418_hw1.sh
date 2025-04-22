#!/bin/bash
echo "Problem 1"
echo "Top 10 Hosts (Jul)"
awk '$9 != 404 { print $1 }' NASA_Jul95.log | sort | uniq -c | sort -nr | head -10
echo "Top 10 Hosts (Aug)"
awk '$9 != 404 { print $1 }' NASA_Aug95.log | sort | uniq -c | sort -nr | head -10
echo ""
echo "Problem 2"
echo "%IP vs hostname (Jul)"
awk '
function is_ip(host) {
  return host ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/
}
{
  total++
  if (is_ip($1)) ip++
  else hostname++
}
END {
  printf "IP requests: %.2f%% (%d)\n", ip/total*100, ip
  printf "Hostname requests: %.2f%% (%d)\n", hostname/total*100, hostname
  printf "Total requests: %d\n", total
}' NASA_Jul95.log
echo "%IP vs hostname (Aug)"
awk '
function is_ip(host) {
  return host ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/
}
{
  total++
  if (is_ip($1)) ip++
  else hostname++
}
END {
  printf "IP requests: %.2f%% (%d)\n", ip/total*100, ip
  printf "Hostname requests: %.2f%% (%d)\n", hostname/total*100, hostname
  printf "Total requests: %d\n", total
}' NASA_Aug95.log
echo ""
echo "Problem 3"
echo "top 10 requests (Jul)"
awk '$9 != 404 { print $7 }' NASA_Jul95.log | sort | uniq -c | sort -nr | head -10
echo "top 10 requests (Aug)"
awk '$9 != 404 { print $7 }' NASA_Aug95.log | sort | uniq -c | sort -nr | head -10
echo ""
echo "Problem 4"
echo "most frequent request types (Jul)"
awk '
{
  gsub(/"/, "", $6)
  if ($6 ~ /^(GET|POST|HEAD|PUT|DELETE|OPTIONS|PATCH)$/) {
    count[$6]++
  }
}
END {
  for (type in count) {
    printf "%8d %s\n", count[type], type
  }
}' NASA_Jul95.log

echo "most frequent request types (Aug)"
awk '
{
  gsub(/"/, "", $6)
  if ($6 ~ /^(GET|POST|HEAD|PUT|DELETE|OPTIONS|PATCH)$/) {
    count[$6]++
  }
}
END {
  for (type in count) {
    printf "%8d %s\n", count[type], type
  }
}' NASA_Aug95.log

echo ""
echo "Problem 5"
echo "404 errors reported (Jul)"
awk '$9 == 404' NASA_Jul95.log | wc -l
echo "404 errors reported (Aug)"
awk '$9 == 404' NASA_Aug95.log | wc -l
echo ""
echo "Problem 6"
echo "most frequent response code and percentage (Jul)"
awk '{ count[$9]++ } END {
  max_code = ""; max_count = 0; total = 0
  for (code in count) {
    total += count[code]
    if (count[code] > max_count) {
      max_count = count[code]
      max_code = code
    }
  }
  printf "Most frequent response code: %s\n", max_code
  printf "Count: %d\n", max_count
  printf "Percentage of total responses: %.2f%%\n", (max_count / total) * 100
}' NASA_Jul95.log
echo "most frequent response code and percentage (Aug)"
awk '{ count[$9]++ } END {
  max_code = ""; max_count = 0; total = 0
  for (code in count) {
    total += count[code]
    if (count[code] > max_count) {
      max_count = count[code]
      max_code = code
    }
  }
  printf "Most frequent response code: %s\n", max_code
  printf "Count: %d\n", max_count
  printf "Percentage of total responses: %.2f%%\n", (max_count / total) * 100
}' NASA_Aug95.log
echo ""
echo "Problem 7"
echo "time of day active/quiet (Jul)"
awk '
{
  match($4, /[0-9]{2}\/[A-Za-z]+\/[0-9]{4}:([0-9]{2}):/, m)
  hour = m[1]
  count[hour]++
}
END {
  min = 1e9
  max = 0
  for (h = 0; h < 24; h++) {
    hr = sprintf("%02d", h)
    n = count[hr]+0
    if (n > max) { max = n; max_hr = hr }
    if (n < min) { min = n; min_hr = hr }
  }
  printf "Most active hour:   %s:00 - %s:59 with %d requests\n", max_hr, max_hr, max
  printf "Quietest hour:      %s:00 - %s:59 with %d requests\n", min_hr, min_hr, min
}' NASA_Jul95.log

echo "time of day active/quiet (Aug)"
awk '
{
  match($4, /[0-9]{2}\/[A-Za-z]+\/[0-9]{4}:([0-9]{2}):/, m)
  hour = m[1]
  count[hour]++
}
END {
  min = 1e9
  max = 0
  for (h = 0; h < 24; h++) {
    hr = sprintf("%02d", h)
    n = count[hr]+0
    if (n > max) { max = n; max_hr = hr }
    if (n < min) { min = n; min_hr = hr }
  }
  printf "Most active hour:   %s:00 - %s:59 with %d requests\n", max_hr, max_hr, max
  printf "Quietest hour:      %s:00 - %s:59 with %d requests\n", min_hr, min_hr, min
}' NASA_Aug95.log

echo ""
echo "Problem 8"
echo "the biggest overall response (in bytes) and the average (Jul)"
awk '$10 ~ /^[0-9]+$/ {
  total += $10
  if ($10 > max) max = $10
  count++
}
END {
  printf "Max response size: %d bytes\n", max
  printf "Average response size: %.2f bytes\n", total / count
}' NASA_Jul95.log
echo "the biggest overall response (in bytes) and the average (Aug)"
awk '$10 ~ /^[0-9]+$/ {
  total += $10
  if ($10 > max) max = $10
  count++
}
END {
  printf "Max response size: %d bytes\n", max
  printf "Average response size: %.2f bytes\n", total / count
}' NASA_Aug95.log
echo ""
echo "Problem 9"
awk '
{
  gsub(/\[/, "", $4)
  split($4, ts, ":")
  split(ts[1], dmy, "/")
  day = dmy[1] + 0
  month = dmy[2]
  year = dmy[3]
  dates[day] = 1
}
END {
  for (d = 1; d <= 31; d++) {
    if (!(d in dates)) {
      printf "outage date: %02d/Aug/1995\n", d
    }
  }
}' NASA_Aug95.log
echo ""
echo "Problem 10"
echo "Most activity date in Aug"
awk '
{
  match($4, /\[([0-9]{2}\/[A-Za-z]+\/[0-9]{4})/, m)
  date = m[1]
  count[date]++
}
END {
  max = 0
  for (d in count) {
    if (count[d] > max) {
      max = count[d]
      max_date = d
    }
  }
  printf "Most active date: %s with %d requests\n", max_date, max
}' NASA_Aug95.log
echo ""
echo "Problem 11"
echo " least amount of activity date except outage dates"
awk '
{
  match($4, /\[([0-9]{2}\/[A-Za-z]+\/[0-9]{4})/, m)
  date = m[1]
  count[date]++
}
END {
  min = 1e9
  for (d in count) {
    if (count[d] < min) {
      min = count[d]
      min_date = d
    }
  }
  printf "Least active (non-outage) date: %s with %d requests\n", min_date, min
}' NASA_Aug95.log







