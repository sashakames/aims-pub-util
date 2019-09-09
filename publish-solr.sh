CMIP6_done=/p/user_pub/publish-queue/CMIP6-maps-done
CMIP6_err=/p/user_pub/publish-queue/CMIP6-maps-err
CMIP6_ready=/p/user_pub/publish-queue/CMIP6-maps-ready

for i in `seq 50000` ; do

    for map in `ls $CMIP6_ready` ; do
        
        mapfn=$CMIP6_ready/$map

        esgpublish --project cmip6 --set-replica --map $mapfn --service fileservice --noscan --publish
        
        if [ $? == 0 ]  ; then 
    	   mv $mapfn $CMIP6_done
        else
            mv $mapfn $CMIP6_err
    	   echo "[ERROR] esgpublish esgsearch $map"
        fi

    done

sleep 300
 
done

echo "$0 $dt completed" | sendmail ames4@llnl.gov
