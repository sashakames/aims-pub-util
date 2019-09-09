cert=$HOME/.globus/certificate-file

for id in `cat $1` ; do
    

    wget --no-check-certificate --ca-certificate $cert --certificate $cert --private-key $cert --verbose -O response.xml --post-data="id=$id|aims3.llnl.gov" https://esgf-node.llnl.gov/esg-search/ws/retract

    cat response.xml
    rm response.xml
done
