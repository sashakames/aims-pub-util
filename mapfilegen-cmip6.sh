# Input - a list of directories


input_dir=/p/user_pub/publish-queue/CMIP6-list-todo
done_dir=/p/user_pub/publish-queue/CMIP6-list-done


cmip6_dirlst=$1

for m in `ls $cmip6_dirlst` 
do

	echo BEGIN $m
	for n in `cat $m` 
		do 
		echo RUN $n
		time esgmapfile -i ../ini --project cmip6 --outdir /p/user_pub/CMIP6-maps-todo --max-processes 32 $n 

	done
	mv $m $done_dir
done