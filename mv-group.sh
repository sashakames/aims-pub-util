sg synda

SRCBASE=/p/css03/scratch
TARGETPATH=/p/user_pub/publish-queue/CMIP6-list-todo

PREFIX=$1


SRCPATH="${SRCBASE}/${PREFIX}"
DESTPATH=`echo $SRCPATH | sed s/scratch/esgf_publish/`
DOTDELIM=`echo $PREFIX | sed s/'\/'/'\.'/g`

for ITEM in `ls ${SRCPATH}` ; do

    
    SRC=$SRCPATH/$ITEM
	if [ ! -d $SRC ] ; then

	    echo source path $SRC does not exist!
	    exit
	fi

	#mkdir -m=775 -p $DESTPATH 
	
	if [ -d $DESTPATH/$ITEM ] ; then
	    echo $DESTPATH/$ITEM exists
	    continue
	fi
	    

	mv $SRC $DESTPATH

	if [ ! -d $DESTPATH ] ; then

	    echo dest path $DESTPATH does not exist! 
	    exit
	fi


# TODO make * spec a parameter if you can
	echo $DESTPATH/$ITEM >> $TARGETPATH/$DOTDELIM.lst

done
chgrp climatew $TARGETPATH/$DOTDELIM.lst
chmod 774 $TARGETPATH/$DOTDELIM.lst

