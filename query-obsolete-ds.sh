td=`date +%F`

rfn=retracted.$td.txt
vfn=versrepl.$td.txt
lfn=latest.$td.txt

cert=$HOME/.globus/certificate-file

python search-check.py  R  > $rfn
python search-check.py  L > $lfn
python search-check.py  V >  $vfn

cat $lfn $rfn | sort | uniq -c > sorted.retracted.$td.txt
awk '{if ($1 == 2) print $2}' sorted.retracted.$td.txt > dup.retracted.$td.txt

cat $vfn $lfn | sort | uniq -c > sorted.versrepl.$td.txt
awk '{if ($1 == 2) print $2}' sorted.versrepl.$td.txt > dup.versrepl.$td.txt


mkdir obsolete-ds-$td

for id in `cat dup.versrepl.$td.txt` ; do
    
    wget --no-check-certificate --ca-certificate $cert --certificate $cert --private-key $cert --verbose -O response.xml --post-data="id=$id" https://esgf-node.llnl.gov/esg-search/ws/retract

    cat response.xml
    rm response.xml
done

mv $rfn $vfn $lfn sorted.retracted.$td.txt dup.retracted.$td.txt sorted.versrepl.$td.txtdup.versrepl.$td.txt res-$td


