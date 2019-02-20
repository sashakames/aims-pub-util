input_dir=/p/user_pub/publish-queue/CMIP6-list-todo
done_dir=/p/user_pub/publish-queue/CMIP6-list-done


for m in `ls $input_dir` 
do

	echo BEGIN $m
	bash mapfilegen-cmip6.sh $input_dir $m
	if [ $? -ne 0 ] ; then
		echo "Mapfile gen failed " $m | sendmail ames4@llnl.gov
		exit 1
	fi	
	mv $m $done_dir
done