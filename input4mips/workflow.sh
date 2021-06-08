. $HOME/.bashrc

cmdname=$0
echo $cmdname
cmddir=`pwd`
INDIR=$1
mapenv=esgmap

upone=`dirname $INDIR`
DESTDIR="$upone/done"

pubenv=esgfpub
#inidir=$HOME/config/publisher-configs/ini
inidir=/p/user_pub/publish-queue/tmp
tmpdir=$HOME/tmpfiles
mkdir -p $tmpdir

archdir=$HOME/pub-workflows-archive
pushd $tmpdir

pycmd=$cmddir/get_dir_lst.py
success=0

for fn in `ls $INDIR` ; do

    fullpath=$INDIR/$fn    
    [ 0 -eq `echo $fullpath | grep -c json` ] ; res=$?

    if [ $res -eq 0 ] ; then
        echo "skipping $fullpath"
        continue
    fi
    
    echo "-- $fullpath"
    for jsonfn in `cat $fullpath` 
        do
        conda activate
        python $pycmd $jsonfn > tmplst
        conda activate $mapenv
        for dirn in `cat tmplst` 
            do
            esgmapfile --project input4mips -i $inidir $dirn
            done
        conda activate $pubenv
        for mapfn in `ls mapfiles` ; do
          ls -l mapfiles/$mapfn
          esgpublish --json $jsonfn --verbose --project input4mips --no-auth --map mapfiles/$mapfn
          if [ ! $? ] ; then
              echo [ERROR] 
              success=1
          fi
         done
        jsonbase=`basename $jsonfn`
        
        tar -cf $archdir/$jsonbase.tar mapfiles
        rm -rf mapfiles
    done
    
    
    if [ $success ] 
    then
            mv $fullpath $archdir
                
    else
        echo [FAIL] $fullpath
    fi

done

popd