input_dir=/p/user_pub/publish-queue/CMIP6-list-todo
done_dir=/p/user_pub/publish-queue/CMIP6-list-done


for i in `seq 1 5000` ; do


	count=`ls $input_dir | wc -l` 

	if [ $count -eq 0 ] ; then

	    echo No Files found `date`
		sleep 500
    	continue
	fi

	for m in `ls $input_dir` 
	do

		echo BEGIN $m
		bash mapfilegen-cmip6.sh $input_dir $m
		if [ $? -ne 0 ] ; then
			echo  "mapfilegen-cmip6.sh [FAIL] " $m
			echo  "mapfilegen-cmip6.sh [FAIL] " $m | sendmail ames4@llnl.gov	
			exit	 1	
		fi	
	mv $m $done_dir
	done


done
