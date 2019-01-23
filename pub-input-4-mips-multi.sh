#  $1 is the target dir for the batch
#  $2 is list of data direcoties
#  $3 is list of json in a text file

directory_name=$1
data_directory_list=$2
json_list=$3

pushd /esg/config/esgcet
cp esg.input4mips.ini.prep esg.input4mips.ini
popd

mkdir -p $directory_name/mapfiles

update_file=$directory_name/$directory_name.update

echo "Preprocessing json"

if [ ! -f $json_list ] ; then
    echo ERROR $json_list does not exists
    exit -1
fi

#cat $json_list | python ../aims-pub-util/proc-input4MIPS-json-r3.py facet-list | uniq > $update_file
cat $json_list | python ./proc-input4MIPS-json-r3.py facet-list | uniq > $update_file

if [ $? -ne 0 ] ; then
    echo ERROR detected
    exit
fi

for i in `cat $data_directory_list`; do
    echo $i
    ##(done)## esgmapfile --project input4mips --outdir $directory_name/mapfiles $i
done

## exit ### TESTING 

if [ $? -ne 0 ] ; then
    echo ERROR detected
    exit
fi

pushd /esg/config/esgcet
cp esg.input4mips.ini.pub esg.input4mips.ini
popd

for map in `ls -1 $directory_name/mapfiles/*.map` ; do
    esgpublish --project input4mips --map $map
    if [ $? -ne 0 ] ; then
        echo ERROR detected
        continue
    fi
done

for map in `ls -1 $directory_name/mapfiles/*.map` ; do
    esgpublish --project input4mips --map $map --noscan --thredds --service fileservice --no-thredds-reinit
    if [ $? -ne 0 ] ; then
        echo ERROR detected
        continue
    fi
done

esgpublish --project input4mips --thredds-reinit

esgadd_facetvalues --project input4mips --map $update_file --noscan --thredds --service fileservice

if [ $? -ne 0 ] ; then
    echo ERROR detected
    exit
fi

esgpublish --project input4mips --map $directory_name/mapfiles --noscan --publish

if [ $? -ne 0 ] ; then
    echo ERROR detected
    exit
fi


