thedate=`date +%y%m%d`


todo=`ls /p/user_pub/CMIP6-maps-todo/ | wc -l`
donee=`ls /p/user_pub/CMIP6-maps-done/ | wc -l`
echo $i $todo $donee >> dset-count.$thedate.txt


