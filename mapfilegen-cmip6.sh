# Input - a list of directories

cmip6_dirlst=$1

for n in `cat $cmip6_dirlst`

do time esgmapfile -i ../ini --project cmip6 --outdir /p/user_pub/CMIP6-maps-todo --max-processes 32 $n 

done