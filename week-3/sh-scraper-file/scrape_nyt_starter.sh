#!/bin/bash

#API_KEY = $1
#echo "API Key: $API_KEY"

# this pulls data from the NY Times developer api through the 'Data Science at the Command Line' book linux environment
#script adapted from 'Data Science at the Command Line' book

#https://api.nytimes.com/svc/search/v2/articlesearch.json?q=tariffs&begin_date=20200101&end_date=20251231&page=1&api-key='$API_KEY'

#takes some time as there is a 13 second delay
parallel -j1 --progress --delay 13 --results results "curl -sL "\
"'http://api.nytimes.com/svc/search/v2/articlesearch.json?q=tariffs&’”\
“’begin_date={1}0101&end_date={1}1231&page={2}&sort=newest&api-key='"\
"'{your-api-key}'" ::: {2021..2025} ::: {0..20} > /dev/null

cat results/1/*/2/*/stdout | head -n 5

tree results | head

cat results/1/*/2/*/stdout | jq -c '.response.docs[] | {date: .pub_date, type: .document_type, '\
'title: .headline.main }' > articles

jq -r '[.date, .type, .title] | @csv' articles > tariff-articles.csv

rm articles
rm -r results

wc -l tariff-articles.csv

#< tariff-articles.csv cols -c date cut -dT -f1 | head | csvlook



