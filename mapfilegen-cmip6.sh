# Input - a list of directories


input_dir=/p/user_pub/publish-queue/CMIP6-list-todo
done_dir=/p/user_pub/publish-queue/CMIP6-list-done


for m in `ls $input_dir` 
do

	echo BEGIN $m
	for n in `cat $input_dir/$m` 
		do 
		echo RUN $n
		time esgmapfile -i ../ini --project cmip6 --outdir /p/user_pub/CMIP6-maps-todo --max-processes 32 $n 

	done
	mv $m $done_dir
done