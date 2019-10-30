map=$1
ready_file=$2
exempt=$3

mapfn=$map

echo "BEGINPUB $mapfn"

isreplica="--set-replica"

isethrsm=`echo $map | grep -c $exempt` 

if [ $isethrsm -gt 0 ] ; then
    isreplica=""
fi

esgpublish --project cmip6 $isreplica --map $mapfn

if [ $? != 0 ]  ; then 

    echo "[FAIL] esgpublish postgres $map"
    mv $mapfn $CMIP6_err
    ok=1
    continue
fi

esgpublish --project cmip6 $isreplica --map $mapfn --service fileservice --noscan --thredds --no-thredds-reinit

if [ $? != 0 ]  ; then 

    echo "[FAIL] esgpublish thredds $map"
    mv $mapfn $CMIP6_err
    ok=1
    continue
fi
echo $mapfn >> $ready_file
