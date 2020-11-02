cert=/export/ames4/.globus/certificate-file
echo 'Pass4esg*' | myproxy-logon -S -s esgf-node.llnl.gov -l sashakames -o $cert -t 72
chmod 64 $cert

