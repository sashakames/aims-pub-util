# Input - a list of directories


input_dir=/p/user_pub/publish-queue/CMIP6-list-todo
done_dir=/p/user_pub/publish-queue/CMIP6-list-done

count=`ls $input_dir | wc -l` 

if [ $count -eq 0 ] ; then

    echo No Files found
    exit
fi

for m in `ls $input_dir` 
do

	echo BEGIN $m
	log_loc=$input_dir/$m
	
	ok=0

	for n in `cat $log_loc` 
		do 
		echo RUN $n
		time esgmapfile -i ../ini --project cmip6 --outdir /p/user_pub/CMIP6-maps-todo --max-processes 16 $n 
		if [ $? != 0 ] ; then
		    echo "[FAIL] esgmapfile $n in $log_loc"
		    exit
		fi
	done

	mv $log_loc $done_dir
	       
done
