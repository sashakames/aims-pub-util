# Input - a list of directories

input_dir=$1
m=$2

outdir=/p/user_pub/publish-queue/CMIP6-maps-todo


inidir=/export/ames4/pub/ini

i=0

input_file=$input_dir/$m

resume_number=`cat current_line`
last_file=`cat last_file`

echo "'$input_file'" "'$last_file'"

echo PROCESSING $input_file

echo $input_file > last_file

for n in `cat $input_file` 
do
    i=$(( $i + 1 ))
    if [ $input_file == $last_file ] ; then

	if [ $i -lt $resume_number ] ; then
	    echo SKIPPING $n at $i to resume to $resume_number
	    continue
	fi

    fi

    stop=`cat /tmp/map_status`

    if [ $stop == "true" ] ; then
    	echo Received Stop Notification, exiting before $m $i
	exit 1

    fi


    echo $i > current_line

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
    
done

echo none > last_file
echo 0 > current_line
