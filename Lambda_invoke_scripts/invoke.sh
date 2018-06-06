#!/bin/bash
totalruns=$1
threads=$2
# Time format is year-mon-day hr:min:sec Example "2017-06-01 20:00:00"
# Time must be in quotes
starttime=$3

callservice() {
  totalruns=$1
  threadid=$2
  host=10.0.0.33
  port=8080
  #onesecond=1000
  #echo "args 1=$1 2=$2 3=$3"
  #if [ $threadid -eq 1 ]
  #then
  #  echo "elapsed_time"
  #fi
  #starttime=( $(($(date +%s%N)/1000000)) )
  for (( i=1 ; i <= $totalruns; i++ ))
  do
    json={"\"test_action\"":"\"row_count\"","\"query\"":"\"select\u0020count(*)\u0020from\u0020yelp_db.review;\""}
    time1=( $(($(date +%s%N)/1000000)) )
    #curl -s -S -X POST -H "Content-Type: application/json" https://1w1c5qx5q9.execute-api.us-east-1.amazonaws.com/prod/POST -d $json >/dev/null
    aws lambda invoke --function-name func0515 --region us-east-1 --payload '{"test_action":"row_count","query":"select count(*) from yelp_db.review;"}' selectResponse.txt
    time2=( $(($(date +%s%N)/1000000)) )
    elapsedtime=`expr $time2 - $time1`
	echo "elapsedtime:$elapsedtime"
  done
  #endtime=( $(($(date +%s%N)/1000000)) )
  #diff=`expr $endtime - $starttime`
  #avg=`expr $diff / $totalruns`
  #echo "avg=$avg"
}
export -f callservice

# If a starttime is provide, loop until we reach the start time before calling service
if [ ! -z "$starttime" ]
then
  t1=`date --date="$starttime" +%s`
  echo "Start script at $t1"
  while : ; do
    dt2=`date +%Y-%m-%d\ %H:%M:%S`
    # Compute the seconds since epoch for date 2
    current_time=`date --date="$dt2" +%s`
    sleep .1
    #echo "compare $current_time >= $t1"
    [ "$current_time" -lt "$t1" ] || break
  done
echo "Starting script now... $current_time"
fi

# set up parallel service calls
runsperthread=`echo $totalruns/$threads | bc -l`
runsperthread=${runsperthread%.*}
echo "Setting up test: runsperthread=$runsperthread threads=$threads totalruns=$totalruns"
for (( i=1 ; i <= $threads ; i ++))
do
  arpt+=($runsperthread)
done
parallel --no-notice -j $threads -k callservice {1} {"#"} ::: "${arpt[@]}"
