CMIP6_done=/p/user_pub/publish-queue/CMIP6-maps-done
CMIP6_err=/p/user_pub/publish-queue/CMIP6-maps-err2
CMIP6_ready=/p/user_pub/publish-queue/CMIP6-maps-ready.3
ready_file=/tmp/ready_maps

num_todo=$2

#  first go through

for i in `seq 1 48` ; do 
        
    target_file=/tmp/maplst
    maps_in=$1
    ls $maps_in | head -n $num_todo | sed s:^:${maps_in}/:g > $target_file
    if [ $? != 0 ] ; then
        echo No Mapfiles exiting 1
        exit
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
    touch $ready_file
    echo -n "" > $ready_file


    cat $target_file | parallel -j 4 bash publish-kernel.sh {} $ready_file 'UA-MCM'

    esgpublish --project cmip6 --thredds-reinit

    if [ $? != 0 ]  ; then 
        
        echo "[FAIL] esgpublish thredds reinit"
        echo "publish-this $1 $dt completed [FAIL] to reinit, exiting! last file $ready_file" | sendmail ames4@llnl.gov
	echo true > /tmp/pub_status
        exit
    fi

    MSG='[SUCCESS]'

    for mapfn in `cat $ready_file` ; do

	
        mv $mapfn $CMIP6_ready
        if [ $? != 0 ] ; then
            echo "[ERROR] Moving file to Ready directory"
        fi
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
