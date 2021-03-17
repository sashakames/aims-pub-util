srcdir=/p/user_pub/publish-queue/CMIP6-maps-todo2
dest=/p/user_pub/publish-queue/CMIP6-maps-todo

tmpfile=/tmp/mapslist.tmp

rm $tmpfile

ls $srcdir | grep "map$" > $tmpfile

for x in `cat $tmpfile` ; do
mv $srcdir/$x $dest
done

thedate=`date`

echo `wc -l $tmpfile` files moved at $thedate >> /tmp/moved.log


