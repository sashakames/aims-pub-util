CMIP6_done=/p/user_pub/CMIP6-maps-done

target_file=$1



#  first go through

if [ ! -f $target_file ] ; then
    
    echo target is directory
    target_file=/tmp/maplst
    maps_in=$1
    ls $maps_in/*.map > $target_file
    if [ $? != 0 ] ; then
        echo no files exiting
        exit
    fi
else
    echo target is file
fi

ok=0

dt=`date +%s`
echo BEGIN $dt

for map in `cat $target_file` ; do
    
    mapfn=$map

    echo "BEGIN $mapfn"


	esgpublish --project cmip6 --set-replica --map $mapfn

	if [ $? != 0 ]  ; then 

		echo "[FAIL] esgpublish postgres $map"
		ok=1
		continue
	fi

        esgpublish --project cmip6 --set-replica --map $mapfn --service fileservice --noscan --thredds --no-thredds-reinit

	if [ $? != 0 ]  ; then 

		echo "[FAIL] esgpublish thredds $map"
		ok=1
		continue
	fi

done

esgpublish --project cmip6 --thredds-reinit

if [ $? != 0 ]  ; then 
    
    echo "[FAIL] esgpublish thredds reinit"

    echo "publish-this $1 completed [FAIL]" | sendmail ames4@llnl.gov    
    exit
fi

for map in `cat $target_file` ; do

    mapfn=$map

    esgpublish --project cmip6 --set-replica --map $mapfn --service fileservice --noscan --publish
    
    if [ $? != 0 ]  ; then 

	echo "[FAIL] esgpublish esgsearch $map"
	continue
    fi

    mv  $mapfn $CMIP6_done

done

MSG='[SUCCESS]'


if [ $ok -eq 0 ] ;then

    mv $target_file $CMIP6_done/mapfile_run_$dt.txt

else
    MSG='[ERROR]'

fi

echo "$0 $dt completed $MSG" | sendmail ames4@llnl.gov
