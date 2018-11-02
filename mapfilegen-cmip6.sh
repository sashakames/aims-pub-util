# Input - a list of directories


input_dir=/p/user_pub/publish-queue/CMIP6-list-todo
done_dir=/p/user_pub/publish-queue/CMIP6-list-done


for m in `ls $input_dir` 
do

	echo BEGIN $m
	log_loc=$input_dir/$m
	for n in `cat $log_loc` 
		do 
		echo RUN $n
		time esgmapfile -i ../ini --project cmip6 --outdir /p/user_pub/CMIP6-maps-todo --max-processes 16 $n 

	done
	mv $log_loc $done_dir
done
