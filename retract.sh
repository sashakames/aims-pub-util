cert=/p/user_pub/publish-queue/certs/certificate-file

if [ -z $1 ] ; then
    echo "Missing arguments (1) list of datasets (instance ids) (2) server name (shortname)"
    exit
fi

if [ -z $2 ] ; then
    echo "Missing servername (use short name not fqdn)"
    exit
fi


for id in `cat $1` ; do
    

    wget --no-check-certificate --ca-certificate $cert --certificate $cert --private-key $cert --verbose -O response.xml --post-data="id=$id|$2.llnl.gov" https://esgf-node.llnl.gov/esg-search/ws/retract
#    wget --no-check-certificate --ca-certificate $cert --certificate $cert --private-key $cert --verbose -O response.xml --post-data="id=$id" https://esgf-node.llnl.gov/esg-search/ws/retract

    cat response.xml
    rm response.xml
done
