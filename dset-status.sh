thedate=`date +%y%m%d`
fn=/p/user_pub/publish-queue/dset-status/dset-count.$thedate.txt

thetime=`date +%H%M`

todo=`ls /p/user_pub/publish-queue/CMIP6-maps-todo/ | wc -l`
donee=`ls /p/user_pub/publish-queue/CMIP6-maps-done/ | wc -l`
err=`ls /p/user_pub/publish-queue/CMIP6-maps-err/ | wc -l`
err2=`ls /p/user_pub/publish-queue/CMIP6-maps-err2/ | wc -l`

echo $thetime $todo $donee $err $err2 >> $fn


