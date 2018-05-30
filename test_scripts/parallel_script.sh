totalruns=$1
threads=$2

echo "elapsed_time"
callservice() {
  totalruns=$1
  threadid=$2
  if [ $threadid -eq 1 ]
  then
    echo "elapsed_time"
  fi
  for ((i=1;i<=$totalruns;i++));
  do
	time1=( $(($(date +%s%N)/1000000)) )
    curl \
        --request POST \
        --max-time 400 \
        --data '{"server_ip":"xx.xxx.xx.xx","query":"delete from yelp_db.tip_backup where likes=150", "output_to": ""}' \
        https://sfx01ruul4.execute-api.us-east-1.amazonaws.com/dev/myT2RdsCall
	time2=( $(($(date +%s%N)/1000000)) )
    elapsedtime=`expr $time2 - $time1`
    echo "$elapsedtime"
done
}
export -f callservice

runsperthread=`echo $totalruns/$threads | bc -l`
runsperthread=${runsperthread%.*}
#echo "Setting up test: runsperthread=$runsperthread threads=$threads totalruns=$totalruns"
for (( i=1 ; i <= $threads ; i ++))
do
  arpt+=($runsperthread)
done
parallel --no-notice -j $threads -k callservice {1} {#} ::: "${arpt[@]}"
