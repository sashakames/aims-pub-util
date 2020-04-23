td=`date +%F`

rfn=retracted.$td.txt
vfn=versrepl.$td.txt
lfn1=latest.1.$td.txt
lfn2=latest.2.$td.txt

server1=aims3
server2=esgf-data1

cert=$HOME/.globus/certificate-file

python search-check.py  R  > $rfn
python search-check.py  V >  $vfn

python search-check.py  L  $server1 > $lfn1
python search-check.py  L  $server2 > $lfn2

destdir=$HOME/pub/logdir/obsolete-ds-$td

mkdir $destdir

for i in 1 2 
do

    lfni="lfn$i"

    serveri="server$i"

    cat ${!lfni} $rfn | sort | uniq -c > sorted.retracted.$i.$td.txt
    awk '{if ($1 == 2) print $2}' sorted.retracted.$i.$td.txt > dup.retracted.$i.$td.txt

    cat $vfn ${!lfni} | sort | uniq -c > sorted.versrepl.$i.$td.txt
    awk '{if ($1 == 2) print $2}' sorted.versrepl.$i.$td.txt > dup.versrepl.$i.$td.txt

    for id in `cat dup.retracted.$i.$td.txt` ; do
    
        wget --no-check-certificate --ca-certificate $cert --certificate $cert --private-key $cert --verbose -O response.xml --post-data="id=$id|${!serveri}.llnl.gov" https://esgf-node.llnl.gov/esg-search/ws/retract

        cat response.xml
        rm response.xml
    done

    mv ${!lfni} sorted.retracted.$i.$td.txt dup.retracted.$i.$td.txt sorted.versrepl.$i.$td.txt dup.versrepl.$i.$td.txt $destdir

done

mv $rfn $vfn $destdir
