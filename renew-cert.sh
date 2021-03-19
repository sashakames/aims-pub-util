cert=/p/user_pub/publish-queue/certs/certificate-file
echo 'Pass4esg*' | myproxy-logon -S -s esgf-node.llnl.gov -l sashakames -o $cert -t 72
chmod 644 $cert

