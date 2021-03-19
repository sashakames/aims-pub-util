thedate=`date +%y%m%d`
fn=/p/user_pub/publish-queue/dset-status/dset-count.$thedate.txt

thetime=`date +%H%M`

todo=`ls /p/user_pub/publish-queue/CMIP6-maps-todo/ | wc -l`
donee=`ls /p/user_pub/publish-queue/CMIP6-maps-done/ | wc -l`
err=`find /p/user_pub/publish-queue/CMIP6-maps-err/ | grep map$ | wc -l`

res=`ls /p/user_pub/publish-queue/CMIP6-list-todo | wc -l`

if [ $res -gt 0 ] ; then

    ltodo=`wc -l /p/user_pub/publish-queue/CMIP6-list-todo/* | tail -n1 | awk '{print $1}'`
else

    ltodo=0

fi
echo $thetime $todo $donee $err $ltodo >> $fn


