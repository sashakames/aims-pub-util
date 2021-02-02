import sys

PREFIX_LEN = 3  # eg /p/user_pub/work/
PATH_LEN = 9 # includes the version

last = PREFIX_LEN + PATH_LEN 

for line in sys.stdin:

    parts = line.split()
    
    path = parts[1]

    checksum = parts[0]

    ts = parts[2]  # timestamp

    sz = parts[3].strip()  # size

    pp2 = path.split('/')

    dset_id = ".".join(pp2[PREFIX_LEN  :last]) + "#" + pp2[last][1:]
    
    out_arr = []
    out_arr.append(dset_id)
    out_arr.append(path)
    out_arr.append(sz)
    out_arr.append("mod_time=" + ts)
    out_arr.append("checksum=" + checksum)
    out_arr.append("checksum_type=SHA256")

    print(" | ".join(out_arr))

