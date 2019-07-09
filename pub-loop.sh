export UVCDAT_ANONYMOUS_LOG=no
for i in `seq 1 50000`  ; do
    stop=`cat /tmp/pub_status`
    
    if [ $stop == "true" ] ; then
	echo Received Stop Notification, exiting 
	exit
    fi 
    
    time bash ../aims-pub-util/publish-cmip6-replica.sh /p/user_pub/CMIP6-maps-todo 120
    sleep 10 

done

echo "CMIP6 publication loop completed" | sendmail ames4@llnl.gov
