CMIP6_done=/p/user_pub/publish-queue/CMIP6-maps-done
CMIP6_err=/p/user_pub/publish-queue/CMIP6-maps-err2

instance_id=3

CMIP6_ready=/p/user_pub/publish-queue/CMIP6-maps-ready.${instance_id}

tmp_file=/tmp/ready.${instance_id}

for i in `seq 50000` ; do


    ls $CMIP6_ready > $tmp_file
    lscount=`cat $tmp_file | wc -l`
    echo "PROCESSING $lscount files"

    for map in `cat $tmp_file` ; do


        
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
