sg synda

SRCBASE=/p/css03/scratch/
TARGETPATH=/p/user_pub/publish-queue/CMIP6-list-todo

PREFIX=$1


SRCPATH="${SRCBASE}/${PREFIX}"
DESTPATH=`echo $SRCPATH | sed s/scratch/esgf_publish/`
DOTDELIM=`echo $PREFIX/$2 | sed s/'\/'/'\.'/g`

ITEM=$SRCPATH/$2

if [ ! -d $ITEM ] ; then

echo source path $ITEM does not exist!
exit
fi

mkdir -m=775 -p $DESTPATH 


mv $ITEM $DESTPATH

if [ ! -d $DESTPATH ] ; then

 echo dest path $DESTPATH does not exist! 
 exit
fi

# TODO make * spec a parameter if you can
ls -d $DESTPATH/$2/*/*  > $TARGETPATH/$DOTDELIM.lst

chgrp climatew $TARGETPATH/$DOTDELIM.lst
chmod 774 $TARGETPATH/$DOTDELIM.lst

