# run.sh script to run on aimstdn5 or 6 to process movement of files

umask 002

cd /home/ames4/CMIP6-replica
previ=`cat lasti`

firsti=$(( $previ + 1000 ))
lasti=$(( $previ + 5000 ))  # decrement this for fewer


for i in `seq $firsti 1000 $lasti` ; do 
    nohup bash ../aims-pub-util/mv-list.sh replica-batch-$i > replica-batch-$i.log

done

echo $lasti > lasti
