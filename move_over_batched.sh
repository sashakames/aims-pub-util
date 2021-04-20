srcdir=/p/user_pub/publish-queue/CMIP6-maps-ready
dest=/p/user_pub/publish-queue/CMIP6-maps-todo

tmpfile=/tmp/mapslist.tmp

rm $tmpfile

ls $srcdir | grep "map$" > $tmpfile

count=$1
for x in `cat $tmpfile` ; do

    echo mv $srcdir/$x $dest
    count=$(( $count - 1 ))

    if [ $count -eq 0 ] ; then
        echo sleep $2
    fi
done

thedate=`date`

#echo `wc -l $tmpfile` files moved at $thedate >> /tmp/moved.log


