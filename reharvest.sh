cert="/export/ames4/.globus/certificate-file"

for xml in `cat $1` ; do
    
    skip=`cat /tmp/harvest_skip`

    if [ $skip == "true" ] ; then

	sleep 10
    else
    
	wget --no-check-certificate --ca-certificate $cert  --certificate $cert --private-key $cert --verbose --post-data="uri=http://aims3.llnl.gov/thredds/catalog/esgcet/$xml&metadataRepositoryType=THREDDS" https://esgf-node.llnl.gov/esg-search/ws/harvest    
	cat harvest
	echo
	rm harvest
    fi

done