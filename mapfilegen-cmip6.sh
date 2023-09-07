# Input - a list of directories

cmd_dir=`dirname $0`
input_dir=$1
m=$2
outdir=/gpfs/wolf/cli137/proj-shared/publisher-work/mapfiles/$3
i=0
input_file=$input_dir/$m
current_line_file=$HOME/workdir/$3.current_line
last_filename_file=$HOME/workdir/$3.last_filename

resume_number=`cat $current_line_file`
last_file=`cat $last_filename_file`

echo "'$input_file'" "'$last_file'"

echo PROCESSING $input_file

echo $input_file > $last_filename_file  

for n in `cat $input_file` 
do
    i=$(( $i + 1 ))
    if [ $input_file == $last_file ] ; then

	  if [ $i -lt $resume_number ] ; then
	     echo SKIPPING $n at $i to resume to $resume_number
	     continue
	  fi

    fi

    echo $i > $current_line_file

    
    echo RUN $n $i

    if [ ! -d $n ] ; then 
        echo missing perms or mount [FAIL] $m $i 
        echo missing perms or mount [FAIL] $m $i | sendmail ames4@llnl.gov
        exit 1
    fi

    chk=`echo $n | grep -c CREATE`
    
    if [ $chk -ne 1 ] ; then
    

         tmpmap=$HOME/workdir/$3.tmp.map
         rm -f $tmpmap
         for infn in `python cmip5_enumerate.py $n` ; do
           bash $cmd_dir/get_meta.sh $n/$infn | python3 $cmd_dir/create_dset.py CMIP6 >> $tmpmap
         done
         if [ -f $tmpmap ] ; then
             outfn=`head -n1 $tmpmap | cut -d' ' -f1 | sed s/'\#'/'\.v'/`
             outfullpath=$outdir/${outfn}.map
             echo moving to $outfullpath
             mv $tmpmap $outfullpath
# 	esgmapfile -i $inidir --project cmip6 --outdir $outdir --max-processes 8 --no-cleanup $n
        fi
    fi
    
    if [ $? -ne 0 ]; then
 	  echo esgmapfile $n [FAIL] $m $i
	  echo esgmapfile $n [FAIL] $m $i | sendmail ames4@llnl.gov
  	  exit 1
    fi   
    

    
done

echo none > $last_filename_file
echo 0 > $current_line_file
