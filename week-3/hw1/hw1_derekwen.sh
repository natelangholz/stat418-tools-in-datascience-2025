#!/usr/bin/env bash
# Derek Wen STATS 418 HW1

# Drop any Windows CRs if present
sed -i 's/\r$//' "$0" 2>/dev/null || true

# Force POSIX “C” locale so sort/uniq never barf on odd bytes
export LC_ALL=C
set -euo pipefail

for file in NASA_Jul95.log NASA_Aug95.log; do
  [ ! -f "$file" ] && continue
  echo "===== $file ====="

  # 1) Top 10 hosts (≠404)
  echo "1) Top 10 hosts (≠404):"
  awk '$9 != 404 { print $1 }' "$file" \
    | sort | uniq -c | sort -rn | head -10 || true

  # 2) % from IP vs hostname
  total=$(wc -l <"$file")
  ips=$(awk '$1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/' "$file" | wc -l)
  hosts=$((total - ips))
  echo "2) IP:   $ips ($(awk -v i="$ips" -v t="$total" 'BEGIN{printf "%.2f%%",i/t*100}'))"
  echo "   Host: $hosts ($(awk -v h="$hosts" -v t="$total" 'BEGIN{printf "%.2f%%",h/t*100}'))"

  # 3) Top 10 requests (≠404)
  echo "3) Top 10 requests (≠404):"
  awk '$9 != 404 { print $6,$7 }' "$file" \
    | sed 's/"//g' | sort | uniq -c | sort -rn | head -10 || true

  # 4) Methods (only GET, HEAD, POST)
  echo "4) Methods:"
  awk '$6 ~ /^"(GET|HEAD|POST)/ { gsub(/"/,"",$6); print $6 }' "$file" \
    | sort | uniq -c | sort -rn

  # 5) 404 errors
  err=$(awk '$9==404{c++}END{print c+0}' "$file")
  echo "5) 404 errors: $err"

  # 6) Top status & percentage
  read -r cnt code <<<"$(awk '{print $9}' "$file" \
                            | sort | uniq -c | sort -rn | head -1)"
  pct=$(awk -v c="$cnt" -v t="$total" 'BEGIN{printf "%.2f%%",c/t*100}')
  echo "6) $code occurred $cnt times ($pct)"

  # 7) Activity by hour
  echo "7) By hour:"
  awk '{ sub(/^\[/,"",$4); split($4,a,/:/); print a[2] }' "$file" \
    | sort | uniq -c | sort -rn

  # 8) Max & average bytes
  maxb=$(awk '{print $10}' "$file" | sort -n | tail -1)
  avgb=$(awk '{sum+=$10;cnt++}END{printf "%.0f",sum/cnt}' "$file")
  echo "8) Max bytes: $maxb"
  echo "   Avg bytes: $avgb"

  # 9) Outages (>1h) for August only
  if [[ "$file" == *Aug95.log ]]; then
    echo "9) Outages (>1h):"
    # Prefer the in‑awk mktime approach if available
    if awk 'BEGIN{mktime("1970 1 1 0 0 0"); exit 0}' 2>/dev/null; then
      awk 'BEGIN {
          mon["Jan"]=1; mon["Feb"]=2; mon["Mar"]=3; mon["Apr"]=4;
          mon["May"]=5; mon["Jun"]=6; mon["Jul"]=7; mon["Aug"]=8;
          mon["Sep"]=9; mon["Oct"]=10; mon["Nov"]=11; mon["Dec"]=12;
        }
        {
          ts = substr($4,2)                   # e.g. "01/Aug/1995:00:00:01"
          split(ts,a,/[\/:]/)
          t = mktime(a[3]" "mon[a[2]]" "a[1]" "a[4]" "a[5]" "a[6])
          if (prev && t - prev > 3600) {
            gap = t - prev
            h = int(gap/3600); m = int((gap%3600)/60)
            printf "  %s → %s (%dh %02dm)\n", prev_ts, ts, h, m
          }
          prev = t; prev_ts = ts
        }' "$file"
    else
      # Fallback using GNU date
      cut -d'[' -f2 "$file" | cut -d']' -f1 | cut -d' ' -f1 \
        | sort -u | while read ts; do
          epoch=$(date -d "$ts -0400" +%s)
          if [[ -n "${prev_epoch:-}" && $((epoch-prev_epoch)) -gt 3600 ]]; then
            gap=$((epoch-prev_epoch))
            h=$((gap/3600)); m=$(((gap%3600)/60))
            printf "  %s → %s (%dh %02dm)\n" "$prev_ts" "$ts" "$h" "$m"
          fi
          prev_epoch=$epoch; prev_ts=$ts
        done
    fi
  fi

  # 10) Busiest date
  echo "10) Busiest date:"
  grep '\[' "$file" \
    | cut -d'[' -f2 | cut -d':' -f1 \
    | sort | uniq -c | sort -rn | head -1 || true

  # 11) Quietest date (exclude outage days in August)
  echo "11) Quietest date:"
  if [[ "$file" == *Aug95.log ]]; then
    grep '\[' "$file" \
      | cut -d'[' -f2 | cut -d':' -f1 \
      | grep -vE "01/Aug/1995|02/Aug/1995|03/Aug/1995" \
      | sort | uniq -c | sort -n | head -1 || true
  else
    grep '\[' "$file" \
      | cut -d'[' -f2 | cut -d':' -f1 \
      | sort | uniq -c | sort -n | head -1 || true
  fi

  echo
done
