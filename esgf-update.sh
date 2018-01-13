if [ -z $1 ] ; then 
    echo "Need short hostname, eg pcmdi11 or esgf-node"
    exit
fi

#echo 'Pass4esg*' | myproxy-logon -s esgf-node.llnl.gov -l sashakames -o ~/.globus/certificate-file -S -t 72

for line in `cat var-list` ; do

   sid=`awk FS='-' '{print $1}'`
   vid=`awk FS='-' '{print $2}'`

   sed s/XXXX/$vid/ update.xml.tmpl  | sed s/YYYY/sid/ > update.xml

   wget --no-check-certificate --ca-certificate /export/ames4/.globus/certificate-file --certificate /export/ames4/.globus/certificate-file --private-key /export/ames4/.globus/certificate-file --verbose --post-file=update.xml "https://$1.llnl.gov/esg-search/ws/update"

   cat update
   rm update
done