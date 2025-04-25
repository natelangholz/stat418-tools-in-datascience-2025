echo -e "\n----------"
echo -e "Timothy Tu - Stat 418 HW 1"
echo -e "----------\n"

echo -e "1. List the top 10 web sites from which requests came (non-404 status).\n"

# We can avoid requests with 404 in column 9, and look for where requests came from in column 1

echo -e "For NASA_Jul95.log, the top 10 websites which requests came (non-404 status):"
awk '$9 != 404 {print $1}' NASA_Jul95.log | sort | uniq -c | sort -nr | head
echo -e "\n"
echo -e "For NASA_Aug95.log, the top 10 websites which requests came (non-404 status):"
awk '$9 != 404 {print $1}' NASA_Aug95.log | sort | uniq -c | sort -nr | head

echo -e "\n---\n"

echo -e "2.What percentage of host requests came from IP vs hostname?\n"

echo -e "For NASA_Jul95.log:"
awk '{
	if ($1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) {
		ip++
		total++
	} else {
		hosts++
		total++
	}
} END {
	print "IP Address Percentage (NASA_Jul95.log) = ", ip/total*100, "%"
	print "Hostname Percentage (NASA_Jul95.log) = ", hosts/total*100, "%"
}' NASA_Jul95.log

echo -e "\nFor NASA_Aug95.log:"
awk '{
	if ($1 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) {
		ip++
		total++
	} else {
		hosts++
		total++
	}
} END {
	print "IP Address Percentage (NASA_Aug95.log) = ", ip/total*100, "%"
	print "Hostname Percentage (NASA_Aug95.log) = ", hosts/total*100, "%"
}' NASA_Aug95.log

echo -e "\n---\n"

echo -e "3. List the top 10 requests (non-404 status).\n"

echo -e "For NASA_Jul95.log:"
awk '$9 != 404 {print $6, $7}' NASA_Jul95.log | grep '^[[:print:]]*$' | tr -d '"' | sort | uniq -c | sort -nr | head
echo -e "\nFor NASA_Aug95.log:"
awk '$9 != 404 {print $6, $7}' NASA_Aug95.log | grep '^[[:print:]]*$' | tr -d '"' | sort | uniq -c | sort -nr | head

echo -e "\n---\n"

echo -e "4. List the most frequent request types.\n"

echo -e "For NASA_Jul95.log, here are the most frequent request types."
awk '$9 != 404 {print $6}' NASA_Jul95.log | grep '^[[:print:]]*$' | tr -d '"' | sort | uniq -c | sort -nr | head -3
echo -e "\nFor NASA_Aug95.log, here are the most frequent request types."
awk '$9 != 404 {print $6}' NASA_Aug95.log | grep '^[[:print:]]*$' | tr -d '"' | sort | uniq -c | sort -nr | head -3

echo -e "\n---\n"

echo -e "5. How many 404 errors were reported in the log?\n"

echo -e "For NASA_Jul95.log:"
awk '{
	if ($9 == 404) {
		error++
	}
} END {
	print "There were", error, "404 errors within NASA_Jul95.log."
}' NASA_Jul95.log
echo -e "\nFor NASA_Aug95.log:"
awk '{
	if ($9 == 404) {
		error++
	}
} END {
	print "There were", error, "404 errors within NASA_Aug95.log."
}' NASA_Aug95.log

echo -e "\n---\n"

echo -e "6. What is the most frequent response code and what percentage of reponses did this account for?\n"

echo -e "For NASA_Jul95.log:"
awk '{print $9}' NASA_Jul95.log | sort | uniq -c | sort -nr | head -1
awk '{
	if ($9 == 200) {
		common++
		total++
	} else {
		total++
	}
} END {
	print "The most common error in NASA_Jul95.log was error 200, making up", common/total*100, "% of responses."
}' NASA_Jul95.log

echo -e "\nFor NASA_Aug95.log:"
awk '{print $9}' NASA_Aug95.log | sort | uniq -c | sort -nr | head -1
awk '{
	if ($9 == 200) {
		common++
		total++
	} else {
		total++
	}
} END {
	print "The most common error in NASA_Aug95.log was error 200, making up", common/total*100, "% of responses."
}' NASA_Aug95.log

echo -e "\n---\n"

echo -e "7. What time of day is the site active? When is it quiet?\n"

echo -e "For NASA_Jul95.log, here are the number of requests at each hour"
awk '{split($4, a, ":"); print a[2]}' NASA_Jul95.log | sort | uniq -c 
echo -e "Based on this information, it seems that the most active time of day is around noon between 10:00 - 16:00."
echo -e "The quietest period seems to be around the middle of the night between 02:00 - 07:00."

echo -e "\nFor NASA_Aug95.log, here are the number of requests at each hour"
awk '{split($4, a, ":"); print a[2]}' NASA_Aug95.log | sort | uniq -c 
echo -e "Based on this information, it seems that the most active time of day is around afternoon between 12:00 - 16:00."
echo -e "The quietest period seems to be around the middle of the night between 01:00 - 05:00."

echo -e "\n---\n"

echo -e "8. What is the biggest overall response (in bytes) and what is the average?\n"

echo -e "For NASA_Jul95.log: "
awk '{
	if ($10 ~ /^[0-9]+$/) {
		if ($10 > bigbyte) {
			bigbyte = $10
			totalbyte = totalbyte + $10
			count++
		} else {
			totalbyte = totalbyte + $10
			count++
		}
	}
} END {
	print "The biggest overall response in bytes is: ", bigbyte, "bytes"
	print "The average number of bytes is: ", totalbyte/count, "bytes"
}' NASA_Jul95.log

echo -e "\nFor NASA_Aug95.log: "
awk '{
	if ($10 ~ /^[0-9]+$/) {
		if ($10 > bigbyte) {
			bigbyte = $10
			totalbyte = totalbyte + $10
			count++
		} else {
			totalbyte = totalbyte + $10
			count++
		}
	}
} END {
	print "The biggest overall response in bytes is: ", bigbyte, "bytes"
	print "The average number of bytes is: ", totalbyte/count, "bytes"
}' NASA_Aug95.log

echo -e "\n---\n"

echo -e "9. There was a hurricane during August where there was no data collected. Identify the times and dates when data was not collected for August. How long was the outage?\n"

echo -e "Let's first see if there are any missing dates."
awk '{print substr($4, 2, 11)}' NASA_Aug95.log | cut -d: -f1 | sort | uniq
echo -e "We can see that there is no data for August 2nd. We can get the last log from August 1st and the first log from August 3rd to get a good approximation for the hurricane."
awk '$4 ~ /01\/Aug\/1995/ {gsub(/\[/, "", $4); print $4 }' NASA_Aug95.log | sort | tail -1
awk '$4 ~ /03\/Aug\/1995/ {gsub(/\[/, "", $4); print $4 }' NASA_Aug95.log | sort | head -1
echo -e "The hurricane from August caused an outage that potentially lasted from August 1st, 1995 at 14:52:01 until August 3rd, 1995 at 04:36:13, lasting a total of 1 day, 13 hours, 44 minutes, and 12 seconds."

echo -e "\n---\n"

echo -e "10. Which date saw the most activity overall?\n"

echo -e "For NASA_Jul95.log: "
awk '{print substr($4, 2, 11)}' NASA_Jul95.log | cut -d: -f1 | sort | uniq -c | sort -nr | head -1
echo -e "July 13th, 1995 saw the most amount of activity for NASA_Jul95.log."

echo -e "\nFor NASA_Aug95.log: "
awk '{print substr($4, 2, 11)}' NASA_Aug95.log | cut -d: -f1 | sort | uniq -c | sort -nr | head -1
echo -e "August 31st, 1995 saw the most amount of activity for NASA_Aug95.log."

echo -e "\n---\n"

echo -e "11. Excluding the outage dates which date saw the least amount of activity?\n"

echo -e "For NASA_Jul95.log: "
awk '{print substr($4, 2, 11)}' NASA_Jul95.log | cut -d: -f1 | sort | uniq -c | sort -nr | tail -5
echo -e "July 28th, 1995 saw the least amount of activity for NASA_Jul95.log."

echo -e "\nFor NASA_Aug95.log: "
awk '{print substr($4, 2, 11)}' NASA_Aug95.log | cut -d: -f1 | sort | uniq -c | sort -nr | tail -5
echo -e "August 26th, 1995 saw the least amount of activity for NASA_Aug95.log."

echo -e "\n---\n"

echo -e "End of Shell script"
echo -e "----------"

















