y=`sha256sum $1`
x=`stat -c"%Z %s" $1`

echo $y $x