# week-3/hw1/hw1.sh   (or overwrite hw1-starter.sh)
#!/usr/bin/env bash

export LC_ALL=C
export LANG=C      

###############################################################################
# STAT 418 – Homework 1
# One‑shot analyser for NASA access logs (Jul / Aug 1995)
# Usage:   ./hw1.sh NASA_Jul95.log   > NASA_Jul95_report.txt
#          ./hw1.sh NASA_Aug95.log   > NASA_Aug95_report.txt
###############################################################################

set -eu

# ----------------------------- fetch data (first run only) -------------------
if [[ ! -f NASA_Jul95.log ]]; then
	echo "Downloading log files…"
	curl -k -L --fail --progress-bar \
	     https://atlas.cs.brown.edu/data/web-logs/NASA_Jul95.log  -o NASA_Jul95.log
	curl -k -L --fail --progress-bar \
	     https://atlas.cs.brown.edu/data/web-logs/NASA_Aug95.log  -o NASA_Aug95.log
	
fi

# ----------------------------- choose the file -------------------------------
log="$1"
[[ -z "${log:-}" || ! -f "$log" ]] && { echo "Usage: $0 <logfile>"; exit 1; }

echo "=============================="
echo "Report for $log"
echo "=============================="

non404='($9 != 404)'        # awk condition – status column
verb_col=6 
path_col=7
ipv4='^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$'

# -----------------------------------------------------------------------------#
# 1. Top‑10 source hosts (non‑404)                                             #
# -----------------------------------------------------------------------------#
printf "\n1) Top‑10 host names / IPs (non‑404):\n"
awk "$non404 {print \$1}" "$log" | sort | uniq -c | sort -nr | head

# 2. Hostname vs IP share
printf "\n2) Percentage of IP vs hostname:\n"
awk -v ipre="$ipv4" '{ if ($1 ~ ipre) ip++; else host++ } END { tot=ip+host;
  printf "IP = %.2f%%   Hostname = %.2f%%\n", 100*ip/tot, 100*host/tot }' "$log"

# 3. Top‑10 requested resources (non‑404)
printf "\n3) Top‑10 requested resources (non‑404):\n"
awk -v pc="$path_col" '$9 != 404 { gsub(/"/,"",$pc); print $pc }' "$log" |
  sort | uniq -c | sort -nr | head

# 4. Request verbs frequency
printf "\n4) Request verb frequency:\n"
awk -v vc="$verb_col" '
{
    gsub(/"/,"",$vc);          # strip quotes from the verb field
    v = $vc;                   # actual verb text
    if (v ~ /^[A-Z]+$/)        # keep only all‑caps HTTP verbs
        verbs[v]++
}
END {
    for (v in verbs) printf "%s\t%d\n", v, verbs[v]
}' "$log" | sort -nr -k2

# 5. Count 404 errors
printf "\n5) Total 404 errors:\n"
awk '($9 == 404) { c++ } END { print c }' "$log"

# 6. Most common status code
printf "\n6) Most common status code:\n"
awk '{ sc[$9]++ } END { for (s in sc) if (sc[s]>max){max=sc[s]; code=s}
      printf "%s with %.2f%% (%d of %d)\n", code, 100*max/NR, max, NR }' "$log"

# 7. Active vs quiet hour
printf "\n7) Hourly activity (UTC in log):\n"
awk '{
        split($4,t,":");                             # hour is field after date
        hr = substr(t[2],1,2); h[hr]++
     }
     END{
        max = -1; min = -1
        for(i=0;i<24;i++){
            cnt = h[sprintf("%02d",i)]+0
            if(cnt>max){ max=cnt; maxhr=sprintf("%02d",i) }
            if(min==-1 || cnt<min){ min=cnt; minhr=sprintf("%02d",i) }
        }
        printf "Most active : %s (%d req)\nLeast active: %s (%d req)\n",
               maxhr,max,minhr,min
     }' "$log"

# 8. Max & mean response bytes
printf "\n8) Response sizes:\n"
awk '$10 ~ /^[0-9]+$/ {sum+=$10; if($10>max) max=$10; n++}
     END { printf "Max = %d bytes   Mean = %.1f bytes\n", max, sum/n }' "$log"

# 9‑11. Extra August questions
if [[ "$log" == *Aug95* ]]; then
  printf "\n9‑11) August outage & busiest / quietest days:\n"
  awk '{ gsub(/\[/,"",$4); split($4,d,":"); day=d[1]; cnt[day]++ } END {
        for (k in cnt) print k,cnt[k] }' "$log" | sort -k1M > _days.tsv

  # find gaps (≥24h with zero lines) to identify outage
  awk 'function ts(d,  cmd){ cmd="date -j -f \"%d/%b/%Y\" \""d"\" +%s";
       cmd | getline x; close(cmd); return x }
       NR==1{prev=$1; pts=ts($1)} { cts=ts($1); if(cts-pts>86400){
         gap=(cts-pts)/86400-1; print "Outage from",prev,"to",$1,"(",gap,"days)"}
         prev=$1; pts=cts }' _days.tsv

  # busiest & quietest (non‑zero)
  sort -k2 -nr _days.tsv | head -1 | awk '{print "Most active day :", $1, "(" $2 " req)"}'
  sort -k2 -n  _days.tsv | awk '$2>0{print "Least active day:", $1, "(" $2 " req)"; exit}'
  rm _days.tsv
fi
