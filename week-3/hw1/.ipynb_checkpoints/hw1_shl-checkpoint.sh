#!/bin/bash
export LC_ALL=C


# Check if log file 
if [ $# -eq 0 ]; then
    echo "Usage: $0 <logfile>"
    exit 1
fi

LOGFILE="$1"

echo "Processing file: $LOGFILE"

# (1) List the top 10 web sites from which requests came (non-404 status).
echo "(1) Top 10 websites from which requests came from (Non-404)"
awk '$9 != 404 { print $1 }' "$LOGFILE" | sort | uniq -c | sort -nr | head -10

# (2) What percentage of host requests came from IP vs hostname?
echo "(2) Percent of host requests that came from IP vs hostname"
total_requests=$(wc -l < "$LOGFILE")
ip_requests=$(awk '{print $1}' "$LOGFILE" | grep -E '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)
hostname_requests=$((total_requests - ip_requests))
ip_percentage=$(echo "scale=2; 100 * $ip_requests / $total_requests" | bc)
hostname_percentage=$(echo "scale=2; 100 * $hostname_requests / $total_requests" | bc)

echo "Total requests: $total_requests"
echo "IP requests: $ip_requests ($ip_percentage%)"
echo "Hostname requests: $hostname_requests ($hostname_percentage%)"

# (3) List the top 10 requests (non-404 status)
echo "(3) Top 10 requests (excluding 404 errors)"
awk '$9 != 404 { print $7 }' "$LOGFILE" | sort | uniq -c | sort -nr | head -10

# (4) List the most frequent request types?
echo "(4) Most frequent request types"
awk '{print $6}' "$LOGFILE" | sed 's/"//' | sort | uniq -c | sort -nr

# (5) How many 404 errors were reported in the log?
echo "(5) Count of 404 errors"
errors_404=$(awk '$9 == 404 { count++ } END { print count+0 }' "$LOGFILE")
echo "404 errors: $errors_404"

# (6) What is the most frequent response code and what percentage of reponses did this account for?
echo "(6) Most frequent response code and its percentage"
read most_count most_code <<< $(awk '{ codes[$9]++ } END {
    for (c in codes) printf "%d %s\n", codes[c], c
}' "$LOGFILE" | sort -nr | head -1)
pct=$(echo "scale=2; 100 * $most_count / $total_requests" | bc)
echo "Most frequent code: $most_code ($most_count responses, $pct%)"

# (7) What time of day is the site active? When is it quiet?
echo "(7) Hourly activity (busiest vs. quietest)..."
hourly=$(awk '{ split($4,t,":"); print t[2] }' "$LOGFILE")
busiest=$(echo "$hourly" | sort | uniq -c | sort -nr | head -1 | awk '{print $2}')
quietest=$(echo "$hourly" | sort | uniq -c | sort -n  | head -1 | awk '{print $2}')
echo "Busiest hour: ${busiest}:00"
echo "Quietest hour: ${quietest}:00"

# (8) What is the biggest overall response (in bytes) and what is the average?
echo "(8) Max and average response size (bytes)"
awk '$10 ~ /^[0-9]+$/ {
    total += $10
    n++
    if ($10 > max) max = $10
}
END {
    printf "Max size: %d bytes\n", max
    printf "Avg size: %.2f bytes\n", total/n
}' "$LOGFILE"

# (9) Identify the hurricane outage in August
if [[ "$LOGFILE" == *"Aug95.log" ]]; then
  echo "(9) Hurricane outage (no data collected) in August"
  outage=$(awk '
  BEGIN{
    maxGap=0;
    # month→number map
    mon["Jan"]=1; mon["Feb"]=2; mon["Mar"]=3; mon["Apr"]=4;
    mon["May"]=5; mon["Jun"]=6; mon["Jul"]=7; mon["Aug"]=8;
    mon["Sep"]=9; mon["Oct"]=10; mon["Nov"]=11; mon["Dec"]=12;
  }
  {
    # strip leading [
    tstr=$4; gsub(/\[/,"",tstr);
    # split into [DD,Mon,YYYY,HH,MM,SS]
    split(tstr,a,/[\/:]/);
    # build epoch
    epoch = mktime(a[3] " " mon[a[2]] " " a[1] " " a[4] " " a[5] " " a[6]);
    if (NR>1) {
      gap = epoch - prev;
      if (gap > maxGap) {
        maxGap = gap;
        start = prev;
        end   = epoch;
      }
    }
    prev = epoch;
  }
  END {
    # print as: start end duration_in_seconds
    printf "%s %s %d\n",
      strftime("%d/%b/%Y:%H:%M:%S", start),
      strftime("%d/%b/%Y:%H:%M:%S", end),
      maxGap;
  }
  ' "$LOGFILE")

  read start_dt end_dt gap_sec <<< "$outage"
  echo "Outage start: $start_dt"
  echo "Outage end:   $end_dt"

  # human‑readable 
  hrs=$((gap_sec/3600))
  mins=$(((gap_sec%3600)/60))
  secs=$((gap_sec%60))
  echo "Duration: ${hrs}h ${mins}m ${secs}s"
fi

# (10) Which date saw the most activity?
echo "(10) Date with most requests"
read max_count max_date <<< $(
  awk '{
    gsub(/\[/,"",$4);
    split($4,dt,":");
    d=dt[1];
    counts[d]++;
  }
  END {
    for (d in counts) print counts[d], d;
  }' "$LOGFILE" | sort -nr | head -1
)
echo "Most active date: $max_date ($max_count requests)"

# (11) Excluding the outage dates, which date saw the least activity?
echo "(11) Date with least requests (excluding outage dates)"
if [[ "$LOGFILE" == *"Aug95.log" ]]; then
  start_date=${start_dt%%:*}
  end_date=${end_dt%%:*}

  read min_count min_date <<< $(
    awk -v sd="$start_date" -v ed="$end_date" '{
      gsub(/\[/,"",$4);
      split($4,dt,":");
      d=dt[1];
      # skip any day that saw no data (the outage days)
      if (d != sd && d != ed) counts[d]++;
    }
    END {
      # find the minimum
      first=1
      for (d in counts) {
        if (first || counts[d] < min) {
          min = counts[d]; md = d; first=0;
        }
      }
      print min, md;
    }' "$LOGFILE"
  )
else
  read min_count min_date <<< $(
    awk '{
      gsub(/\[/,"",$4);
      split($4,dt,":");
      counts[dt[1]]++;
    }
    END {
      first=1
      for (d in counts) {
        if (first || counts[d] < min) {
          min = counts[d]; md = d; first=0;
        }
      }
      print min, md;
    }' "$LOGFILE"
  )
fi
echo "Least active date: $min_date ($min_count requests)"