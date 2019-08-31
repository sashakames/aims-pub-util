# Input - a list of directories

input_dir=$1
m=$2

outdir=/p/user_pub/publish-queue/CMIP6-maps-in


inidir=/export/ames4/pub/ini

i=1

for n in `cat $input_dir/$m` 
do
    stop=`cat /tmp/map_status`
    
    if [ $stop == "true" ] ; then
    	echo Received Stop Notification, exiting before $m $i
	exit
    fi


    echo RUN $n $i

    if [ ! -d $n ] ; then 
	echo missing perms or mount [FAIL] $m $i 
	echo missing perms or mount [FAIL] $m $i | sendmail ames4@llnl.gov
	exit 1
    fi
    esgmapfile -i $inidir --project cmip6 --outdir $outdir --max-processes 8 $n 
    
    if [ $? -ne 0 ]; then
	echo esgmapfile $n [FAIL] $m $i
	echo esgmapfile $n [FAIL] $m $i | sendmail ames4@llnl.gov
	exit 1
    fi
    
    i=$(( $i + 1 ))
done
	       
