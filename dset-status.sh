thedate=`date +%y%m%d`
fn=/p/user_pub/publish-queue/dset-status/dset-count.$thedate.txt

thetime=`date +%H%M`

todo=`ls /p/user_pub/publish-queue/CMIP6-maps-todo/ | wc -l`
donee=`ls /p/user_pub/publish-queue/CMIP6-maps-done/ | wc -l`
err=`ls /p/user_pub/publish-queue/CMIP6-maps-err/ | wc -l`

res=`ls /p/user_pub/publish-queue/CMIP6-list-todo | wc -l`

if [ $res -gt 0 ] ; then

    todo=`wc -l /p/user_pub/publish-queue/CMIP6-list-todo/* | tail -n1 | awk '{print $1}'`
else

    todo=0

fi
echo $thetime $todo $donee $err $todo >> $fn


