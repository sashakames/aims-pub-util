fields=11

for n in `cat $1` ; do

	len=`echo $n | awk -v FS='/' '{print NF}'`

	if [ $len == $fields ] ; then
	        dn=`dirname $n`
		pubdn=/p/css03/esgf_publish${dn}

		res=`ls $pubdn`
		echo "PUB $dn ${res}"
		scrdn=/p/css03/scratch${dn}
		res=`ls $scrdn`
		echo "SCR $dn ${res}"

	else
		echo "MOVE /p/css03/scratch/${n}"
	fi
done
