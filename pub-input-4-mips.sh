#  $1 is the target dir for the batch


pushd /esg/config/esgcet
cp esg.input4mips.ini.prep esg.input4mips.ini
popd

mkdir -p $1/mapfiles

update_file=$1/$1.update

echo "Preprocessing json"

cat $3 | python ../aims-pub-util/proc-input4MIPS-json-r3.py facet-list | uniq > $update_file

#TEST="--test"

if [ $? -ne 0 ] ; then

    echo ERROR detected
    exit

fi

esgmapfile --project input4mips --outdir $1/mapfiles $2

if [ $? -ne 0 ] ; then

    echo ERROR detected
    exit

fi

pushd /esg/config/esgcet
cp esg.input4mips.ini.pub esg.input4mips.ini
popd

esgpublish --project input4mips --map $1/mapfiles $TEST

if [ $? -ne 0 ] ; then

    echo ERROR detected
    exit

fi

esgpublish --project input4mips --map $1/mapfiles --noscan --thredds --service fileservice $TEST

if [ $? -ne 0 ] ; then

    echo ERROR detected
    exit

fi

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


