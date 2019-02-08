tds_cats=/esg/content/thredds/esgcet

rm tmp.txt

for i in range $1 $2 ; do

	cat_dir=tds_cats/$i

	for n in $cat_dir/*.xml ; do

		val=`grep -c 'gsiftp://aims3.llnl.gov' $n`

		if [ $val -gt 0 ] ; then
			sed -i s/'gsiftp\:\/\/aims3'/'gsiftp\:\/\/aimsdtn3'/g
			echo $n >> tmp.txt
		fi

	done

done 

esgpublish --project cmip6 --thredds-reinit

for $n in `cat tmp.txt` ; do
	
		
done
