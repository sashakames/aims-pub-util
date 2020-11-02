input_dir=/p/user_pub/publish-queue/CMIP6-list-todo
done_dir=/p/user_pub/publish-queue/CMIP6-list-done


for i in `seq 1 50000` ; do




	count=`ls $input_dir | wc -l` 

	if [ $count -eq 0 ] ; then

	    echo No Files found `date`
		sleep 500
    	continue
	fi

	for m in `ls $input_dir` 
	do
	    stop=`cat /tmp/map_status`

	    if [ $stop == "true" ] ; then
		echo Received Stop Notification, exiting the outer loops!
		exit
	    fi

	    stop=`cat /tmp/map_status`

	    if [ $stop == "true" ] ; then
		echo Received Stop Notification, exiting the outer loops!
		exit
	    fi


		echo BEGIN $m `date`
		time bash mapfilegen-cmip6.sh $input_dir $m
		if [ $? -ne 0 ] ; then
			echo  "mapfilegen-cmip6.sh [FAIL] " $m
			echo  "mapfilegen-cmip6.sh [FAIL] " $m | sendmail ames4@llnl.gov	
			exit	 1	
		fi	
	mv $input_dir/$m $done_dir
	done

done

echo "CMIP6 mapfile-gen-loop completed" | sendmail ames4@llnl.gov
