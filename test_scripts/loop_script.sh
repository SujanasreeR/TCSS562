echo "elapsed_time,sleep_time_ms"
# loop
for ((i=1;i<=100;i++));
do
time1=( $(($(date +%s%N)/1000000)) )
curl \
--request POST \
--data '{"server_ip":"xx.xxx.xx.xx","query":"select * from user limit 5", "output_to": ""}' \
https://sfx01ruul4.execute-api.us-east-1.amazonaws.com/dev/myT2RdsCall
time2=( $(($(date +%s%N)/1000000)) )
elapsedtime=`expr $time2 - $time1`	
sleeptime=`echo $onesecond - $elapsedtime | bc -l`
sleeptimems=`echo $sleeptime/$onesecond | bc -l`
echo "Run-$i,$json,$elapsedtime,$sleeptimems"
if (( $sleeptime > 0 ))
then
sleep $sleeptimems
fi
echo "\n"
done
