fields=11

for n in `cat $1` ; do

	len=`echo $n | awk -v FS='/' '{print NF}'`

	if [ $len == $fields ] ; then

		dn=`dirname $n`

		res=`ls /p/css03/esgf_publish/$dn`
		echo $dn '"'${res}'"'

	else
		echo "/p/css03/scratch/${n} MOVE"
	fi
done
