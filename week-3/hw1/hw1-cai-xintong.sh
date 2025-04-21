echo 'STAT-418-hw1'
echo 'Name: Xintong Cai'

echo "1. List the top 10 web sites from which requests came (non-404 status) for NASA_Jul95:"
awk '$9 != 404 { print $1 }' NASA_Jul95.log | sort | uniq -c | sort -rn | head
echo ""
