# Input - a list of directories

input_dir=$1
m=$2

inidir=/export/ames4/pub/ini

for n in `cat $input_dir/$m` 
	do 
	echo RUN $n
	if [ ! -d $n ] ; then 
		echo missing perms or mount [FAIL] $m
		exit 1
	fi
	time esgmapfile -i $inidir --project cmip6 --outdir /p/user_pub/CMIP6-maps-todo --max-processes 8 $n 

	if [ $? -ne 0 ]; then
		echo esgmapfile $n [FAIL] $m
		exit 1
	fi

done
	       
