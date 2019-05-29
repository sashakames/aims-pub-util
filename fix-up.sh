tds_cats=/esg/content/thredds/esgcet
rm tmp.txt

cert="/export/ames4/.globus/certificate-file"


for i in `seq $1 $2` ; do

	cat_dir=$tds_cats/$i

	for n in $cat_dir/*.xml ; do

		val=`grep -c 'gsiftp://aims3.llnl.gov' $n`

		if [ $val -gt 0 ] ; then
		    sed -i s/'gsiftp\:\/\/aims3'/'gsiftp\:\/\/aimsdtn3'/g $n
		    bn=`basename $n`
		    echo $i/$bn >> tmp.txt
		fi

	done

done 

esgpublish --project cmip6 --thredds-reinit

for xml in `cat tmp.txt` ; do
    wget --no-check-certificate --ca-certificate $cert  --certificate $cert --private-key $cert --verbose --post-data="uri=http://aims3.llnl.gov/thredds/catalog/esgcet/$xml&metadataRepositoryType=THREDDS" https://esgf-node.llnl.gov/esg-search/ws/harvest    
    cat harvest
    echo
    rm harvest

done
