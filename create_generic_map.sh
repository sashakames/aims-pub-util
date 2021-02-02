if [ -z $1] ; then
    echo Missing required directory argument
    exit
fi

if [ -d $1 ] ; then
    dn=$1
else
    echo "Directory doesn't exist or not readable"
    exit
fi


for fn in `find $dn -f` ; do

    y=`sha256sum $fn`
    x=`stat -c"%Z %s" $fn`

    echo $y $x | python create_dset > $2
done
