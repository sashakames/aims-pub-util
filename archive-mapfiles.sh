maps_loc=p

pushd $maps_loc

thedate='date +%y%m%d' 

tar -czf /p/user_pub/publish-queue/CMIP6-map-tarballs/mapfiles-$thedate.tgz *.map *.txt 

if [ !$? == 0 ] ; then

   echo Error archiving mapfiles $thedate 
   exit 1
fi 

rm *.map *.txt
popd