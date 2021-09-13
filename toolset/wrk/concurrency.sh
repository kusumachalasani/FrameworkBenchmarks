#!/bin/bash

let max_threads=$(cat /proc/cpuinfo | grep processor | wc -l)

echo "---------------------------------------------------------"
echo "Removing any old hyperfoil logs."
rm -rf /tmp/hyperfoil/run/*
echo "---------------------------------------------------------"

echo ""
echo "---------------------------------------------------------"
echo " Running Primer $name"
echo " /wrk/hyperfoil-0.13/bin/wrk2.sh --latency --duration=5s --connections=8 --timeout 8 --threads=8 --rate=10000 $url"
echo "---------------------------------------------------------"
echo ""
/wrk/hyperfoil-0.13/bin/wrk2.sh --latency --duration=5 --connections=8 --timeout 8 --threads=8 --rate=10000 $url
sleep 5

echo "---------------------------------------------------------"
echo "Listing the stats files. If file size is 214KB , then no blocked connection issue."
ls -lrt /tmp/hyperfoil/run/*/stats/failures.csv
echo "---------------------------------------------------------"

echo "---------------------------------------------------------"
echo "Removing any old hyperfoil logs."
rm -rf /tmp/hyperfoil/run/*
echo "---------------------------------------------------------"


echo ""
echo "---------------------------------------------------------"
echo " Running Warmup $name"
echo " /wrk/hyperfoil-0.13/bin/wrk2.sh --latency --duration=${duration} --connections=$max_concurrency --timeout 8 --threads=$max_threads --rate=10000 \"$url\""
echo "---------------------------------------------------------"
echo ""
/wrk/hyperfoil-0.13/bin/wrk2.sh --latency --duration=${duration} --connections=$max_concurrency --timeout 8 --threads=$max_threads --rate=10000 $url
sleep 5

echo "---------------------------------------------------------"
echo "Listing the stats files. If file size is 214KB , then no blocked connection issue."
ls -lrt /tmp/hyperfoil/run/*/stats/failures.csv
echo "---------------------------------------------------------"

echo "---------------------------------------------------------"
echo "Removing any old hyperfoil logs."
rm -rf /tmp/hyperfoil/run/*
echo "---------------------------------------------------------"


for c in $levels
do
echo ""
echo "---------------------------------------------------------"
echo " Concurrency: $c for $name"
echo " /wrk/hyperfoil-0.13/bin/wrk2.sh --latency --duration=$duration --connections=$c --timeout 8 --threads=$(($c>$max_threads?$max_threads:$c)) --rate=10000 \"$url\""
echo "---------------------------------------------------------"
echo ""
STARTTIME=$(date +"%s")
/wrk/hyperfoil-0.13/bin/wrk2.sh --latency --duration=$duration --connections=$c --timeout 8 --threads="$(($c>$max_threads?$max_threads:$c))" --rate=10000 $url
echo "STARTTIME $STARTTIME"
echo "ENDTIME $(date +"%s")"
sleep 2
done

echo "---------------------------------------------------------"
echo "Listing the stats files. If file size is 214KB , then no blocked connection issue."
ls -lrt /tmp/hyperfoil/run/*/stats/failures.csv
echo "---------------------------------------------------------"

echo "---------------------------------------------------------"
echo "Removing any old hyperfoil logs."
rm -rf /tmp/hyperfoil/run/*
echo "---------------------------------------------------------"

