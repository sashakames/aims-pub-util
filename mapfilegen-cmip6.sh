# Input - a list of directories

input_dir=$1
m=$2
outdir=/p/user_pub/CMIP6-maps-todo 
#outdir=/p/user_pub/publish-queue/CMIP6-maps-in

inidir=/export/ames4/pub/ini

for n in `cat $input_dir/$m` 
	do 
	echo RUN $n
	if [ ! -d $n ] ; then 
		echo missing perms or mount [FAIL] $m
		echo missing perms or mount [FAIL] $m | sendmail ames4@llnl.gov
		exit 1
	fi
	esgmapfile -i $inidir --project cmip6 --outdir $outdir --max-processes 8 $n 

	if [ $? -ne 0 ]; then
		echo esgmapfile $n [FAIL] $m
		echo esgmapfile $n [FAIL] $m | sendmail ames4@llnl.gov
		exit 1
	fi

done
	       
