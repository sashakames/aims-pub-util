input_dir=$HOME/workdir/input-$1
done_dir=$HOME/CMIP6-list-done

tmpdir=$HOME/workdir/tmp.$1
logdir=/gpfs/wolf/cli137/proj-shared/publisher-work/logs
mkdir -p $tmpdir

for i in `seq 1 50000` ; do
	count=`ls $input_dir | wc -l` 

	if [ $count -eq 0 ] ; then

	    echo No Files found $1 `date`
		sleep 500
    	continue
	fi

	for m in `ls $input_dir` 
	do

	    stop=`cat $HOME/workdir/map_status`

	    if [ $stop == "true" ] ; then
		echo Received Stop Notification, exiting the outer loops! $1
		exit
	    fi


		echo BEGIN $m `date`
		time nohup bash mapfilegen-cmip6.sh $input_dir $m $1 >> $logdir/$m.$1.log
		if [ $? -ne 0 ] ; then
			echo  "mapfilegen-cmip6.sh [FAIL] " $m $1
			echo  "mapfilegen-cmip6.sh [FAIL] " $m $1 | sendmail ames4@llnl.gov	
			exit	 1	
		fi	
	mv $input_dir/$m $done_dir
	done
done

echo "CMIP6 mapfile-gen-loop completed $1" | sendmail ames4@llnl.gov
