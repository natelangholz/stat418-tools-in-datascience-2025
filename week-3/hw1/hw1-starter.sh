#!/bin/bash
export LC_ALL=C

#the following fetch both NASA log files from the corresponding urls and write. Write them to your local hw1 directory and create a NEW .sh file that can be run on files named:
# NASA_Jul95.log
# NASA_Aug95.log
# sample output: 
# awk -F ' ' '{print $1, $4, $5, $6, $7, $8, $9, $10}' will print the first 10 fields of the log file.
#  i.e. {$1=van15422.direct.ca, $2=-, $3=- $4=[01/Aug/1995:00:07:11 $5=-0400] $6="GET $7=/software/winvn/bluemarb.gif $8=HTTP/1.0" $9=200 $10=104441}

# curl -s https://atlas.cs.brown.edu/data/web-logs/NASA_Jul95.log > NASA_Jul95.log

# curl -s https://atlas.cs.brown.edu/data/web-logs/NASA_Aug95.log > NASA_Aug95.log

#awk '{print $0}' nasa_jul95.log

# filter non-404 requests only
awk '$9 != 404' NASA_Jul95.log > NASA_Jul95_non404.log.tmp
awk '$9 != 404' NASA_Aug95.log > NASA_Aug95_non404.log.tmp

# filter 404 requests only
awk '$9 == 404' NASA_Jul95.log > NASA_Jul95_404.log.tmp
awk '$9 == 404' NASA_Aug95.log > NASA_Aug95_404.log.tmp

#awk -F ' ' '{print $1, $4, $5, $6, $7, $8, $9, $10}' NASA_Jul95.log > NASA_Jul95.log.tmp

# 1. List the top 10 web sites from which requests came (non-404 status).
p1_jul=$(awk '$9 != 404' NASA_Jul95.log | awk '{print $1 "\t" $6}' | sort | uniq -c | sort -nr | head -n 10)
p1_aug=$(awk '$9 != 404' NASA_Aug95.log | awk '{print $1 "\t" $6}' | sort | uniq -c | sort -nr | head -n 10)

# printf "1. List the top 10 web sites from which requests came (non-400 status).\n"
printf "Jul95:\n%s\n" "$p1_jul"
printf "Aug95:\n%s\n " "$p1_aug"

# 2. What percentage of host requests came from IP vs hostname?
total_jul=$(awk '{print $1}' NASA_Jul95.log | wc -l)
total_aug=$(awk '{print $1}' NASA_Aug95.log | wc -l)
#echo $total_jul
#echo $total_aug
ip_jul=$(awk '{print $1}' NASA_Jul95.log | grep -E '^([0-9]+\.){3}[0-9]+$' | wc -l)
ip_aug=$(awk '{print $1}' NASA_Aug95.log | grep -E '^([0-9]+\.){3}[0-9]+$' | wc -l)

#echo $ip_jul
#echo $ip_aug

hostname_jul=$((total_jul - ip_jul))
hostname_aug=$((total_aug - ip_aug))

#echo $hostname_jul
#echo $hostname_aug

# Calculate the percentage of requests from IP and hostname
#ip_jul_perc=$(echo "scale=2; $ip_jul / $total_jul * 100")
#ip_aug_perc=$(echo "scale=2; $ip_aug / $total_aug * 100" | bc)

printf "2. What percentage of host requests came from IP vs hostname?.\n"
awk "ip=$ip_jul" -v "hostname=$hostname_jul" -v "total=$total_jul" 'BEGIN { printf "IP: %.2f%%\n", (ip / total) * 100 }'
awk "ip=$ip_aug" -v "hostname=$hostname_aug" -v "total=$total_aug" 'BEGIN { printf "IP: %.2f%%\n", (ip / total) * 100 }'
# hostname_jul_perc=$(echo "scale=2; $hostname_jul / $total_jul * 100" | bc)
# hostname_aug_perc=$(echo "scale=2; $hostname_aug / $total_aug * 100" | bc)


#3. List the top 10 requests (non-404 status).
p3_jul=$(cat NASA_Jul95_non404.log.tmp | awk '{print $6}' | sed -e 's/[^a-zA-Z]//g' | sort | uniq -c | sort -nr | head -n 10)
p3_aug=$(cat NASA_Aug95_non404.log.tmp | awk '{print $6}' | sed -e 's/[^a-zA-Z]//g' | sort | uniq -c | sort -nr | head -n 10)
printf "3. List the top 10 requests (non-404 status).\n"
printf "Jul95:\n%s\n" "$p3_jul"
printf "Aug95:\n%s\n" "$p3_aug"

#4. List the most frequent request types?

printf "4. List the most frequent request types.\n"
p4_jul=p3_jul | head -n 1 | awk '{print $2}' | cut -d'/' -f1
p4_aug=p3_aug | head -n 1 | awk '{print $2}' | cut -d'/' -f1
printf "Jul95:\n%s\n" "$p4_jul"
printf "Aug95:\n%s\n" "$p4_aug"

#5. How many 404 errors were reported in the log? 
p5_jul=$(cat NASA_Jul95_404.log.tmp | wc -l)
p5_aug=$(cat NASA_Jul95_404.log.tmp | wc -l)

printf "5. How many 404 errors were reported in the log?\n"
printf "Jul95:\n%s\n" "$p5_jul"
printf "Aug95:\n%s\n" "$p5_aug"

#6. What is the most frequent response code and what percentage of reponses did this account for? 


#7. What time of day is the site active? When is it quiet?


#8. What is the biggest overall response (in bytes) and what is the average?


#9.There was a hurricane during August where there was no data collected. Identify the times and dates when data was not collected for August. How long was the outage?


#10. Which date saw the most activity overall?

#11. Excluding the outage dates which date saw the least amount of activity?
