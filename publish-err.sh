CMIP6_done=/p/user_pub/CMIP6-maps-done
CMIP6_err=/p/user_pub/publish-queue/CMIP6-maps-err


for map in `ls $CMIP6_err` ; do
    
    mapfn=$CMIP6_err/$map

    esgpublish --project cmip6 --set-replica --map $mapfn --service fileservice --noscan --publish
    
    if [ $? == 0 ]  ; then 
	mv $mapfn $CMIP6_done
    else
	echo "[ERROR] esgpublish esgsearch $map"
    fi

done


echo "$0 $dt completed" | sendmail ames4@llnl.gov
