#!/bin/bash

let max_threads=$(cat /proc/cpuinfo | grep processor | wc -l)
echo ""
echo "---------------------------------------------------------"
echo " Running Primer $name"
echo " /wrk/hyperfoil-0.13/bin/wrk2.sh -H 'Host: $server_host' -H 'Accept: $accept' -H 'Connection: keep-alive' --latency -d 5 -c 8 --timeout 8 -t 8 --rate 10000 \"${url}2\""
echo "---------------------------------------------------------"
echo ""
/wrk/hyperfoil-0.13/bin/wrk2.sh -H "Host: $server_host" -H "Accept: $accept" -H "Connection: keep-alive" --latency -d 5 -c 8 --timeout 8 -t 8 --rate 10000 "${url}2"
sleep 5

echo ""
echo "---------------------------------------------------------"
echo " Running Warmup $name"
echo " /wrk/hyperfoil-0.13/bin/wrk2.sh -H 'Host: $server_host' -H 'Accept: $accept' -H 'Connection: keep-alive' --latency -d $duration -c $max_concurrency --timeout 8 -t $max_threads --rate 10000 \"${url}2\""
echo "---------------------------------------------------------"
echo ""
/wrk/hyperfoil-0.13/bin/wrk2.sh -H "Host: $server_host" -H "Accept: $accept" -H "Connection: keep-alive" --latency -d $duration -c $max_concurrency --timeout 8 -t $max_threads --rate 10000 "${url}2"
sleep 5

for c in $levels
do
echo ""
echo "---------------------------------------------------------"
echo " Queries: $c for $name"
echo " /wrk/hyperfoil-0.13/bin/wrk2.sh -H 'Host: $server_host' -H 'Accept: $accept' -H 'Connection: keep-alive' --latency -d $duration -c $max_concurrency --timeout 8 -t $max_threads --rate 10000 \"$url$c\""
echo "---------------------------------------------------------"
echo ""
STARTTIME=$(date +"%s")
/wrk/hyperfoil-0.13/bin/wrk2.sh -H "Host: $server_host" -H "Accept: $accept" -H "Connection: keep-alive" --latency -d $duration -c $max_concurrency --timeout 8 -t $max_threads --rate 10000 "$url$c"
echo "STARTTIME $STARTTIME"
echo "ENDTIME $(date +"%s")"
sleep 2
done
