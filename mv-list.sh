sg synda

SRCBASE=/p/css03/scratch
DESTBASE=/p/css03/esgf_publish
TARGETPATH=/p/user_pub/publish-queue/CMIP6-list-todo

LIST=$1

for itbase in `cat $LIST` ; do

    SRC=$SRCBASE/$itbase

    destpart=`dirname $itbase`
    ITEM=`basename $itbase`

    DESTPATH=$DESTBASE/$destpart
    
    if [ ! -d $SRC ] ; then

	echo source path $SRC does not exist!
	exit
    fi

    mkdir -m=775 -p $DESTPATH 
    
    if [ -d $DESTPATH/$ITEM ] ; then
	echo $DESTPATH/$ITEM exists
	continue
    fi

    if [ ! -d $DESTPATH ] ; then

	echo dest path $DESTPATH does not exist! 
	exit
    fi
   
    mv $SRC $DESTPATH


# TODO make * spec a parameter if you can
	echo $DESTPATH/$ITEM >> $TARGETPATH/$LIST.lst

done

chgrp climatew $TARGETPATH/$LIST.lst
chmod 774 $TARGETPATH/$LIST.lst

