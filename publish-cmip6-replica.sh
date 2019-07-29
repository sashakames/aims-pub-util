CMIP6_done=/p/user_pub/publish-queue/CMIP6-maps-done
CMIP6_err=/p/user_pub/publish-queue/CMIP6-maps-err

target_file=$1

num_todo=$2

#  first go through

for i in `seq 1 48` ; do 

if [ ! -f $target_file ] ; then
    
    echo target is directory
    target_file=/tmp/maplst
    maps_in=$1
    ls $maps_in/*.map | head -n $num_todo > $target_file
    if [ $? != 0 ] ; then
        echo No Mapfiles exiting 1
        exit
    fi
else
    echo target is file
fi

stop=`cat /tmp/pub_status`

recipient=`cat /tmp/pub_recip`

if [ $stop == "true" ] ; then
    echo Received Stop Notification, exiting 
    echo "CMIP6 publication halted" | sendmail $recipient
    exit
fi 


ok=0

dt=`date +%y%m%d_%H%M`

count=`wc -l $target_file | awk '{print $1}'`

if [ $count -eq 0 ] ; then
    echo No Mapfiles exiting 2
    exit
fi

echo PROCESSING $count mapfiles $dt $i

for map in `cat $target_file` ; do
    
    mapfn=$map

    echo "BEGINPUB $mapfn"

    isreplica="--set-replica"

    isethrsm=`echo $map | grep -c E3SM` 

    if [ $isethrsm -gt 0 ] ; then

    fi

	esgpublish --project cmip6 $isreplica --map $mapfn

	if [ $? != 0 ]  ; then 

		echo "[FAIL] esgpublish postgres $map"
		ok=1
		continue
	fi

    esgpublish --project cmip6 $isreplica --map $mapfn --service fileservice --noscan --thredds --no-thredds-reinit

	if [ $? != 0 ]  ; then 

		echo "[FAIL] esgpublish thredds $map"
		ok=1
		continue
	fi

done

esgpublish --project cmip6 --thredds-reinit

if [ $? != 0 ]  ; then 
    
    echo "[FAIL] esgpublish thredds reinit"
    echo "publish-this $1 $dt completed [FAIL]" | sendmail ames4@llnl.gov    
    exit
fi

MSG='[SUCCESS]'

for map in `cat $target_file` ; do

    mapfn=$map

    esgpublish --project cmip6 --map $mapfn --service fileservice --noscan --publish
    
    if [ $? != 0 ]  ; then 

	echo "[FAIL] esgpublish esgsearch $map"
    ok=1
    mv  $mapfn $CMIP6_err
	continue
    fi

    mv  $mapfn $CMIP6_done

done

if [ $ok -eq 0 ] ;then

    mv $target_file $CMIP6_done/mapfile_run_$dt.txt

else
    MSG='[ERROR]'
    echo "$0 $dt completed $MSG" | sendmail ames4@llnl.gov
    exit
fi

done

echo "$0 $dt completed $MSG" 
echo "$0 $dt completed $MSG" | sendmail ames4@llnl.gov
