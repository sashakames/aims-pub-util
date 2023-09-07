import sys

#   PREFIX_LEN = 8  # eg /p/user_pub/work/ == 4
PATH_LEN = 9 # includes the version this 

firstid = sys.argv[1]

for line in sys.stdin:

    parts = line.split()
    

    path = parts[1]

    checksum = parts[0]

    ts = parts[2]  # timestamp

    sz = parts[3].strip()  # size

    pp2 = path.split('/')
    idx = pp2.index(firstid)
    last = len(pp2) - 2
    dset_id = ".".join(pp2[idx  :last]) + "#" + pp2[last][1:]
    
    out_arr = []
    out_arr.append(dset_id)
    out_arr.append(path)
    out_arr.append(sz)
    out_arr.append("mod_time=" + ts)
    out_arr.append("checksum=" + checksum)
    out_arr.append("checksum_type=SHA256")

    print(" | ".join(out_arr))

