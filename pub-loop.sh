export UVCDAT_ANONYMOUS_LOG=no
mapsin=/p/user_pub/publish-queue/CMIP6-maps-todo
nitems=600

for i in `seq 1 50000`  ; do
    stop=`cat /tmp/pub_status`
    
    if [ $stop == "true" ] ; then
	echo Received Stop Notification, exiting 
	exit
    fi 

    time bash ../aims-pub-util/publish-cmip6-replica.sh $mapsin $nitems
    sleep 300 
done

echo "CMIP6 publication loop completed" | sendmail ames4@llnl.gov
