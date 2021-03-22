import sys, os, json
from esgcet.update import ESGPubUpdate

CERT = "/p/user_pub/publish-queue/certs/certificate-file"  # PRepend path
INDEX_NODE = "esgf-node.llnl.gov"

def main(args):

    start = int(args[2])

    dsets = json.load(open(args[1]))

    updator = ESGPubUpdate(INDEX_NODE, CERT, verbose=True)

    finish = len(dsets)
    if len(args > 3):
        finish =int(args[3])

    for rec in dsets[start:finish]:

        did = rec['id']
        if "llnl" in did:

            updator.update_core(did, "files")
