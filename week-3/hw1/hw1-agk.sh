#!/bin/bash
export LC_ALL=C   # set locale to C for consistent sorting and parsing behavior

# -----------------------------------------------------------------------------
# Fetch NASA log files if not already present
# -----------------------------------------------------------------------------
curl -s https://atlas.cs.brown.edu/data/web-logs/NASA_Jul95.log  > NASA_Jul95.log
curl -s https://atlas.cs.brown.edu/data/web-logs/NASA_Aug95.log  > NASA_Aug95.log

# -----------------------------------------------------------------------------
# Ensure exactly two filenames are passed in (the July and August logs)
# -----------------------------------------------------------------------------
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 NASA_Jul95.log NASA_Aug95.log"
  exit 1
fi

# Loop over each provided log file
for logfile in "$@"; do
  echo "================ Processing $logfile ================"
  total=$(wc -l < "$logfile")  # count total number of lines (requests)

  # 1) Top 10 hosts making requests, excluding any with a 404 response code
  echo "1) Top 10 hosts (excluding 404s):"
  awk '$9 != 404 { print $1 }' "$logfile" \
    | sort | uniq -c | sort -rn | head -10
  echo

  # 2) Percentage of requests coming from raw IP addresses versus resolved hostnames
  ip_count=$(awk '{ print $1 }' "$logfile" \
               | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' \
               | wc -l)
  host_count=$(( total - ip_count ))
  ip_pct=$(printf "%.2f" "$(echo "$ip_count*100/$total" | bc -l)")
  host_pct=$(printf "%.2f" "$(echo "$host_count*100/$total" | bc -l)")
  echo "2) IP vs hostname requests:"
  echo "   IP       : $ip_count ($ip_pct%)"
  echo "   Hostname : $host_count ($host_pct%)"
  echo

  # 3) Top 10 full HTTP requests (method, path, protocol), excluding 404s
  echo "3) Top 10 full requests (excluding 404s):"
  awk '$9 != 404 { print $6, $7, $8 }' "$logfile" \
    | sort | uniq -c | sort -rn | head -10
  echo

  # 4) Breakdown of HTTP methods used (e.g., GET, POST, HEAD)
  echo "4) Most frequent request methods:"
  awk '{ gsub(/"/,"",$6); print $6 }' "$logfile" \
    | tr -cd '[:print:]\n' \
    | grep -E '^[A-Z]+$' \
    | sort | uniq -c | sort -rn
  echo

  # 5) Total number of 404 (Not Found) errors
  echo "5) Total 404 errors:"
  awk '$9 == 404' "$logfile" | wc -l
  echo

  # 6) The most common response code and its percentage of total requests
  echo "6) Top response code and its %. of total:"
  awk '{ print $9 }' "$logfile" \
    | sort | uniq -c | sort -rn \
    | head -1 \
    | awk -v tot="$total" '{ printf "   Code %s — %d times (%.2f%%)\n", $2, $1, ($1*100)/tot }'
  echo

  # 7) Activity by hour: list counts per hour, then highlight busiest and quietest
  echo "7) Requests per hour (HH):"
  # collect hour field from timestamp, ignoring malformed entries
  hour_counts=$(awk '{
      gsub(/^\[/,"",$4)
      split($4,t,":")
      if (t[2] != "") print t[2]
    }' "$logfile" \
    | sort | uniq -c)
  # display sorted busiest → quietest
  echo "$hour_counts" | sort -nr
  busiest=$(echo "$hour_counts" | sort -nr | head -1 | awk '{printf "%02d:00 (%d requests)", $2, $1}')
  quietest=$(echo "$hour_counts" | sort -n  | head -1 | awk '{printf "%02d:00 (%d requests)", $2, $1}')
  echo "   Busiest hour : $busiest"
  echo "   Quietest hour: $quietest"
  echo "   (Above sorted busiest→quietest.)"
  echo

  # 8) Maximum and average response body size (in bytes)
  echo "8) Response sizes (bytes):"
  awk '$10 ~ /^[0-9]+$/ { sum+=$10; if($10>max) max=$10; c++ }
       END{ printf "   Max = %d\n   Avg = %.2f\n", max, sum/c }' \
       "$logfile"
  echo

  # Analyses only for the August log file
  if [[ "$logfile" == *Aug95.log ]]; then

    # 9) Find the largest time gap (outage) using gawk’s mktime
    echo "9) Detecting largest gap (outage):"
    gawk 'BEGIN{
        # map month names to numbers
        split("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec",M)
        for(i=1;i<=12;i++) mon[M[i]]=i
      }
      {
        # parse timestamp [DD/Mon/YYYY:HH:MM:SS]
        gsub(/^\[/,"",$4)
        split($4,parts,":")
        split(parts[1],dmy,"/")
        d=dmy[1]; m=mon[dmy[2]]; y=dmy[3]
        hr=parts[2]; mi=parts[3]; sec=parts[4]
        ts = mktime(y " " m " " d " " hr " " mi " " sec)
        if(prev_ts){
          gap = ts - prev_ts
          if(gap > max_gap){
            max_gap=gap
            start_ts=prev_raw; end_ts=$4
          }
        }
        prev_ts=ts; prev_raw=$4
      }
      END{
        # convert seconds gap into days, hours, minutes, seconds
        d=int(max_gap/86400); h=int((max_gap%86400)/3600)
        min=int((max_gap%3600)/60); s=max_gap%60
        printf "   Outage from %s → %s\n", start_ts, end_ts
        printf "   Duration = %d days, %d hrs, %d min, %d sec\n", d,h,min,s
        split(start_ts,ss,":"); print ss[1] > ".out_start"
        split(end_ts,  ee,":"); print ee[1]   > ".out_end"
      }' "$logfile"
    echo

    # 10) Date with the highest number of requests
    echo "10) Most active date:"
    awk '{ gsub(/^\[/,"",$4); split($4,t,":"); print t[1] }' "$logfile" \
      | sort | uniq -c | sort -rn | head -1 \
      | awk '{ printf "   %s with %d requests\n", $2, $1 }'
    echo

    # 11) Date with the fewest requests, excluding the outage period
    out_start=$(<.out_start)
    out_end=$(<.out_end)
    echo "11) Least active date (excluding $out_start → $out_end):"
    awk -v S="$out_start" -v E="$out_end" '
      {
        gsub(/^\[/,"",$4)
        split($4,t,":"); day=t[1]
        if(day >= S && day <= E) next  # skip outage window
        cnt[day]++
      }
      END{
        min=1e18
        for(d in cnt){
          if(cnt[d]<min){ min=cnt[d]; low=d }
        }
        printf "   %s with %d requests\n", low, min
      }' "$logfile"

    # clean up temporary files
    rm -f .out_start .out_end
    echo
  fi

done
