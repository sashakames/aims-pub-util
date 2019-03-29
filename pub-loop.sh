export UVCDAT_ANONYMOUS_LOG=no
for i in `seq 1 5000`  
do time bash ../aims-pub-util/publish-cmip6-replica.sh /p/user_pub/CMIP6-maps-todo 120
sleep 300 

done