input_file=$1

#  first go through

#  for esgf v2.5 change to conda
source /etc/esg.env

target_dir="${input_file}-target-dir"
mkdir -p $target_dir

mkdir tmpdir

for path in `cat ${input_file}`; do

	esgprep mapfile --project cmip5 --outdir tmpdir --all-versions $path

	if [ $? != 0 ]  ; then 

		echo "[FAIL] esgprep mapfile $path"
	
	else
		mv tmpdir/* $target_dir

	fi

done

for mapfn in `ls $target_dir` ; do

	esgpublish --project cmip5 --set-replica --map $mapfn

	if [ $? != 0 ]  ; then 

		echo "[FAIL] esgpublish postgres $path"
		continue
	fi

	esgpublish --project cmip5 --set-replica --map $mapfn --service fileservice --noscan --threddds

	if [ $? != 0 ]  ; then 

		echo "[FAIL] esgpublish thredds $path"
		continue
	fi
	esgpublish --project cmip5 --set-replica --map $mapfn --service fileservice --noscan --publish

	if [ $? != 0 ]  ; then 

		echo "[FAIL] esgpublish esgsearch $path"
	
	fi

done



