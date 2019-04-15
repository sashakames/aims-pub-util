thedate=`date +%y%m%d`
fn=/p/user_pub/publish-queue/dset-status/dset-count.$thedate.txt

todo=`ls /p/user_pub/CMIP6-maps-todo/ | wc -l`
donee=`ls /p/user_pub/CMIP6-maps-done/ | wc -l`
echo $i $todo $donee >> $fn


