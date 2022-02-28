import sys, os, json
from esgcet.update import ESGPubUpdate

CERT = "/p/user_pub/publish-queue/certs/certificate-file"  # PRepend path
INDEX_NODE = "esgf-node.llnl.gov"

def main(args):

    print(f"Running filecore-fix with {str(args)}")
    start = int(args[1])

    dsets = json.load(open(args[0]))

    updator = ESGPubUpdate(INDEX_NODE, CERT, silent=True)

    finish = len(dsets)

    if len(args) > 2:
        finish =int(args[2])

        
    for rec in dsets[start:finish]:

        did = rec['id']
        if "llnl" in did:
            updator.update_core(did, "files")

            
if __name__ == '__main__':
    sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.realpath(__file__))))
    main(sys.argv[1:])
