import json, sys

"""
Data with empty results (deleted at all sites)
E3SM, input4MIPs, CREATE, etc – should not be included
Data without any latest=true (original deleted or retracted)
Data without replica=false (original deleted)
Data with replica=false,latest=false pair (original retracted)
Data with replica=false,latest=true, llnl node replica=true,latest=true : mark as “published”
Data with replica=false,latest=true  not on filesystem:  requeue in Synda
Data with replica=false,latest=true  on “scratch”: needs to be moved and put on a “datasets_since” list
Data with replica=false,latest=true  on “esgf_publish”: ready for publication, I will queue these up.
  """     


def orig_check(obj):
    
    for i in range(obj[0]):
        if not obj[2][i] and obj[1][i]:
            return True
    return False

def llnl_check(obj):
    for i, x in obj[0]:
        if "llnl" in x:
            return True
    return False
    
def scope_check(dsid):
    if "input4MIPs" in dsid or (not "CMIP6" in dsid):
        return True
    return False

no_scope = []
deleted = []
nolatest = []
nooriginal_latest = []

missing = []
completed = []
moved = []
published = []
pub_fs_missing = []

for line in open(sys.argv[1]):

    parts = line.split()
    jo = json.loads(parts[2])
    dataset_id = parts[0]
    fspath = parts[1]

    if scope_check(dataset_id):
        no_scope.append(dataset_id)
    elif len(jo[0]) == 0 or all(jo[2]):
        deleted.append(dataset_id)
    elif not any(jo[1]):
        nolatest.append(dataset_id)
    elif any(jo[1]) and not any(jo[2]):
        nooriginal_latest.append(dataset_id)
    elif orig_check(jo):
        if llnl_check(jo):
            if "publish" in fspath:
                published.append(dataset_id)
            else:
                pub_fs_missing.append(dataset_id)
        else:
            if fspath == "none":
                missing.append(dataset_id)
            elif "scratch" in fspath:
                completed.append(dataset_id)
            else:
                moved.append(dataset_id)
    else 
    

THE_MAP = {
    "no_scope" :
    no_scope ,

"deleted" :
deleted,

nolatest 

nooriginal_latest

missing 
completed 
moved 
published 

}

        