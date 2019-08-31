sg synda
umask 002

SRCBASE=/p/css03/scratch
DESTBASE=/p/css03/esgf_publish
TARGETPATH=/p/user_pub/publish-queue/CMIP6-list-todo

LIST=$1

thedate=`date +%y%m%d_%H%M`


TARGETFILE=/tmp/$LIST.$thedate.lst


for itbase in `cat $LIST` ; do

    SRC=$SRCBASE/$itbase

    destpart=`dirname $itbase`
    ITEM=`basename $itbase`

    DESTPATH=$DESTBASE/$destpart
    
    if [ ! -d $SRC ] ; then

	echo source-path-not-exist $SRC
	continue
    fi

    mkdir -p $DESTPATH 
    
    if [ -d $DESTPATH/$ITEM ] ; then
	mkdir $DESTPATH/$ITEM
	
	mv $SRC/* $DESTPATH/$ITEM

	if  [ ! $? == 0 ] ; then
	    echo error-file-move $SRCPATH/$ITEM
	    
	fi

	echo $DESTPATH >> $TARGETFILE
	continue
    fi

    if [ ! -d $DESTPATH ] ; then

	echo dest-path-not-exist $DESTPATH
	continue
    fi
   
    mv $SRC $DESTPATH


# TODO make the choice of the item or encompassing directory a parameter if you can

#	echo $DESTPATH >> $TARGETPATH/$LIST.lst
	echo $DESTPATH >> $TARGETFILE

done

chgrp climatew $TARGETFILE
chmod 664 $TARGETFILE

mv $TARGETFILE $TARGETPATH
