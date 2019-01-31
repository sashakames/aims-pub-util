#  $1 is the target dir for the batch
#  $

json_list=$3

pushd /esg/config/esgcet
cp esg.input4mips.ini.prep esg.input4mips.ini
popd



mkdir -p $1/mapfiles

update_file=$1/$1.update

echo "Preprocessing json"

if [ ! -f $json_list ] ; then
    echo ERROR $json_list does not exists
    exit -1
fi

cat $json_list | python ../aims-pub-util/proc-input4MIPS-json-r3.py facet-list | uniq > $update_file

#TEST="--test"

if [ $? -ne 0 ] ; then

    echo ERROR detected
    exit

fi

dir_list=$2

if [ ! -f $dir_list ] ; then
    echo ERROR $dir_list does not exists
    exit -1
fi

for n in `cat $dir_list`; do

    dn=`dirname $n`
    esgmapfile --project input4mips --outdir $1/mapfiles $dn
done

if [ $? -ne 0 ] ; then

    echo ERROR detected
    exit

fi

pushd /esg/config/esgcet
cp esg.input4mips.ini.pub esg.input4mips.ini
popd


for map in  $1/mapfiles/*.map ; do

esgpublish --project input4mips --map $map

if [ $? -ne 0 ] ; then

    echo ERROR detected
    continue
fi

done

for map in  $1/mapfiles/*.map ; do
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

esgpublish --project input4mips --map $1/mapfiles --noscan --publish

if [ $? -ne 0 ] ; then

    echo ERROR detected
    exit

fi


