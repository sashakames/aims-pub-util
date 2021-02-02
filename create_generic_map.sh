cmdir=`dirname $0`


if [ -z $1 ] ; then
    echo Missing required directory argument
    exit
fi

if [ -d $1 ] ; then
    dn=$1
else
    echo "Directory doesn't exist or not readable"
    exit
fi

if [ -z $2 ] ; then
    echo Missing output file parameter
    exit
fi


for fn in `find $dn -type f` ; do

    y=`sha256sum $fn`
    x=`stat -c"%Z %s" $fn`

    echo $y $x | python $cmdir/create_dset.py 
done > $2
