jul=$"NASA_Jul95.log"
aug=$"NASA_Aug95.log"

echo "Q1"
echo "Jul"
awk '$(NF-1) != 404 {print $1}' $jul | sort | uniq -c | sort -r | sed -e "s/^[ ]*//" | cut -d" " -f2 | head -n10
echo
echo "Aug"
awk '$(NF-1) != 404 {print $1}' $aug | sort | uniq -c | sort -r | sed -e "s/^[ ]*//" | cut -d" " -f2 | head -n10
echo

echo "Q2"
echo "Jul"
nrow_jul=$(wc -l $jul | cut -d" " -f1)
nrow_ip_jul=$(awk '$1 ~ /^[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+$/' $jul | wc -l)
echo "IP percentage:"$((100*nrow_ip_jul/nrow_jul))
echo "Hostname percentage:"$((100-100*nrow_ip_jul/nrow_jul))
echo
echo "Aug"
nrow_aug=$(wc -l $aug | cut -d" " -f1)
nrow_ip_aug=$(awk '$1 ~ /^[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+\.[[:digit:]]+$/' $aug | wc -l)
echo "IP percentage:"$((100*nrow_ip_aug/nrow_aug))
echo "Hostname percentage:"$((100-100*nrow_ip_aug/nrow_aug))
echo

echo "Q3"
echo "Jul"
awk '$(NF-1) != 404 {print $6" "$7" "$8}' $jul | sort | uniq -c | sort -r | sed -e "s/^[ ]*//" | cut -d" " -f2-4 | head -n 10
echo
echo "Aug"
awk '$(NF-1) != 404 {print $6" "$7" "$8}' $aug | sort | uniq -c | sort -r | sed -e "s/^[ ]*//" | cut -d" " -f2-4 | head -n 10
echo

echo "Q4"
echo "3 most frequent request types for each month:"
echo "Jul"
awk '{print $6}' $jul | sort | uniq -c | sort -r | sed -e "s/^[ ]*//" | cut -d'"' -f2 | head -n 3
echo
echo "Aug"
awk '{print $6}' $aug | sort | uniq -c | sort -r | sed -e "s/^[ ]*//" | cut -d'"' -f2 | head -n 3
echo

echo "Q5"
echo "Jul"
awk '$(NF-1) == 404 {print $(NF-1)}' $jul | wc -l
echo
echo "Aug"
awk '$(NF-1) == 404 {print $(NF-1)}' $aug | wc -l
echo

echo "Q6"
echo "Jul"
most_frequent_jul=$(awk '{print $(NF-1)}' $jul | sort | uniq -c | sort -r | sed -e "s/^[ ]*//" | cut -d" " -f1 | head -n 1)
echo $(awk '{print $(NF-1)}' $jul | sort | uniq -c | sort -r | sed -e "s/^[ ]*//" | cut -d" " -f2 | head -n 1)": "$((100*most_frequent_jul/nrow_jul))"%"
echo
echo "Aug"
most_frequent_aug=$(awk '{print $(NF-1)}' $aug | sort | uniq -c | sort -r | sed -e "s/^[ ]*//" | cut -d" " -f1 | head -n 1)
echo $(awk '{print $(NF-1)}' $aug | sort | uniq -c | sort -r | sed -e "s/^[ ]*//" | cut -d" " -f2 | head -n 1)": "$((100*most_frequent_aug/nrow_aug))"%"
echo

echo "Q7"
echo "Jul"
echo "5 most active hours:"
awk '{print $4}' $jul | awk 'NF' | cut -d":" -f2 | sort | uniq -c | sort -r | head -n 5 | sed -e "s/^[ ]*//" | cut -d" " -f2
echo "5 least active hours:"
awk '{print $4}' $jul | awk 'NF' | cut -d":" -f2 | sort | uniq -c | sort | head -n 5 | sed -e "s/^[ ]*//" | cut -d" " -f2
echo
echo "Aug"
echo "5 most active hours:"
awk '{print $4}' $aug | awk 'NF' | cut -d":" -f2 | sort | uniq -c | sort -r | head -n 5 | sed -e "s/^[ ]*//" | cut -d" " -f2
echo "5 least active hours:"
awk '{print $4}' $aug | awk 'NF' | cut -d":" -f2 | sort | uniq -c | sort | head -n 5 | sed -e "s/^[ ]*//" | cut -d" " -f2
echo

echo "Q8"
echo "Jul"
echo "Max"
awk '$10 ~ /^[[:digit:]]+$/ {print $10}' $jul | sort -r | head -n 1
echo "Avg"
total_byte_jul=$(awk '$NF ~ /^[[:digit:]]+$/ {print $NF}' $jul | awk '{sum_jul+=$1} END {print sum_jul}')
valid_row_jul=$(awk '$NF ~ /^[[:digit:]]+$/ {print $NF}' $jul | wc -l)
echo $((total_byte_jul/valid_row_jul))
echo
echo "Aug"
echo "Max"
awk '$10 ~ /^[[:digit:]]+$/ {print $10}' $aug | sort -r | head -n 1
echo "Avg"
total_byte_aug=$(awk '$NF ~ /^[[:digit:]]+$/ {print $NF}' $aug | awk '{sum_aug+=$1} END {print sum_aug}')
valid_row_aug=$(awk '$NF ~ /^[[:digit:]]+$/ {print $NF}' $aug | wc -l)
echo $((total_byte_aug/valid_row_aug))
echo

echo "Q9"
unique_hours=$(awk '{print $4}' $aug | cut -d"[" -f2 | cut -d":" -f1-2 | uniq)
outage_hours=$(for hour in $(for date in $(seq -f"%02g/Aug/1995" 31); do seq -f"$date:%02g" 0 23; done); do if [ $(echo $unique_hours | grep -c $hour) == 0 ]; then echo $hour; fi; done)
echo "The outage lasts from $(echo $outage_hours | cut -d" " -f1):00 to $(echo $outage_hours | awk '{print $NF}'):00 for $(echo $outage_hours | wc -w) hours."
echo

echo "Q10"
echo "Jul"
awk '{print $4}' $jul | cut -d"[" -f2 | cut -d":" -f1 | sort | uniq -c | sort -r | sed -e "s/^[ ]*//" | cut -d" " -f2 | head -n 1
echo
echo "Aug"
awk '{print $4}' $aug | cut -d"[" -f2 | cut -d":" -f1 | sort | uniq -c | sort -r | sed -e "s/^[ ]*//" | cut -d" " -f2 | head -n 1
echo

echo "Q11"
echo "Jul"
awk '{print $4}' $jul | awk 'NF' | cut -d"[" -f2 | cut -d":" -f1 | sort | uniq -c | sort | sed -e "s/^[ ]*//" | cut -d" " -f2 | head -n 1
echo
echo "Aug"
for date in $(awk '{print $4}' $aug | awk 'NF' | cut -d"[" -f2 | cut -d":" -f1 | sort | uniq -c | sort | sed -e "s/^[ ]*//" | cut -d" " -f2); do for outage in $(seq -f"%02g/Aug/1995" 1 3); do if [ $date != $outage ]; then echo $date; fi; done; done | uniq -c | sed -e "s/^[ ]*//" | awk '$1 == 3 {print $2}' | head -n 1
