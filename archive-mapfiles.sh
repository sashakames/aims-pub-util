umask 002

maps_loc=/p/user_pub/CMIP6-maps-done

thedate=`date +%y%m%d` 

tar -czf /p/user_pub/publish-queue/CMIP6-map-tarballs/mapfiles-$thedate.tgz $maps_loc

if [ $? != 0 ] ; then

   echo Error archiving mapfiles $thedate 
   exit 1
fi 


for n in `ls $maps_loc` ; do

    rm $maps_loc/$n
done