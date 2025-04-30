#!/bin/bash

LOGS="NASA_Jul95.log NASA_Aug95.log"

# Helper to turn month abbreviation into number (gawk func)
read -r -d '' MONTH_FUNC <<'EOF'
function mon(m) { return (index("JanFebMarAprMayJunJulAugSepOctNovDec", m) + 2) / 3 }
EOF

echo
echo "1) Top‑10 remote hosts (non‑404 requests)"
cat $LOGS | awk '$9 != 404 {print $1}' \
  | sort | uniq -c | sort -nr | head -10
echo "------------------------------------------------------"

echo
echo "2) Host field: IP vs. hostname (percentage)"
cat $LOGS | awk '
  {
    if ($1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) ip++;   # dotted quad
    else                          host++;
  }
  END {
    total = ip + host;
    printf "IP: %.2f%%  (%d)\nHostname: %.2f%%  (%d)\n",
           100*ip/total, ip, 100*host/total, host;
  }'
echo "------------------------------------------------------"

echo
echo "3) Top‑10 requested resources (non‑404)"
cat $LOGS | awk '$9 != 404' \
  | awk -F'"' '{print $2}' \
  | sort | uniq -c | sort -nr | head -10
echo "------------------------------------------------------"

echo
echo "4) Most frequent request methods"
grep -oP '"\K[A-Z]+' $LOGS \
  | sort | uniq -c | sort -nr
echo "------------------------------------------------------"


echo
echo "5) Total number of 404 errors"
cat $LOGS | awk '$9 == 404 {c++} END {print c}'
echo "------------------------------------------------------"

echo
echo "6) Most common response code (+ its share)"
cat $LOGS | awk '{codes[$9]++; total++}
  END {
    for (c in codes) print codes[c], c;
  }' \
  | sort -nr | awk 'NR==1 {printf "%s (%.2f%%)\n", $2, 100*$1/total}'
echo "------------------------------------------------------"

echo
echo "7) Activity by hour (all days)"
cat $LOGS | awk '
  { split($4,dt,":"); gsub("\\[","",dt[1]); hr=dt[2]; hrs[hr]++ }
  END {
    for (h=0; h<24; h++) {
      printf "%02d:00  %d\n", h, hrs[h]+0
    }
  }' \
  | sort -nr -k2,2 | head -1 | \
  awk '{print "Most active hour:", $1 " (" $2 " requests)"}'
cat $LOGS | awk '
  { split($4,dt,":"); gsub("\\[","",dt[1]); hr=dt[2]; hrs[hr]++ }
  END {
    min=1e9; for (h in hrs) if (hrs[h]<min) {min=hrs[h]; quiet=h}
    printf "Least active hour: %02d:00 (%d requests)\n", quiet, min;
  }'
echo "------------------------------------------------------"

echo
echo "8) Byte counts (payload size)"
cat $LOGS | awk '
  $10 != "-" {bytes=$10; sum+=bytes; c++; if(bytes>max) max=bytes}
  END {printf "Largest = %d bytes | Average = %d bytes\n", max, sum/c}'
echo "------------------------------------------------------"

echo
echo "9) August outage (gap > 1 h, reported once)"
gawk -v OFS='\t' '
'"$MONTH_FUNC"'
BEGIN { prev = 0 }
/Aug\/1995/ {
  split($4, d, "[/\\[:]");
  day  = d[1]; monAbbr=d[2]; year=d[3]; hr=d[4]; mn=d[5]; sc=d[6];
  epoch = mktime(year" "mon(monAbbr)" "day" "hr" "mn" "sc);
  if (prev && epoch - prev > 3600) {
    print strftime("%d/%b/%Y:%H:%M:%S", prev), \
          "→", \
          strftime("%d/%b/%Y:%H:%M:%S", epoch), \
          "(" int((epoch-prev)/3600) " h gap)"
    exit
  }
  prev = epoch
}' NASA_Aug95.log
echo "------------------------------------------------------"

echo
echo "10) Busiest calendar day overall"
cat $LOGS | awk '
  { gsub("\\[","",$4); split($4,a,":"); day=a[1]; hits[day]++ }
  END { for (d in hits) print hits[d], d }' \
  | sort -nr | head -1
echo "------------------------------------------------------"

echo
echo "11) Least‑active day (excluding outage date 02/Aug/1995)"
cat $LOGS | awk '
  { gsub("\\[","",$4); split($4,a,":"); day=a[1]; hits[day]++ }
  END { for (d in hits) if (d!="02/Aug/1995") print hits[d], d }' \
  | sort -n | head -1
echo "------------------------------------------------------"
