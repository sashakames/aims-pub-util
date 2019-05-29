import sys

for line in open(sys.argv[1]):

    parts = line.split()
    
    path = parts[1]

    checksum = parts[0]

    ts = parts[2]  # timestamp

    sz = parts[3].strip()  # size

    pp2 = path.split('/')

    dset_id = ".".join(pp2[4:5]) + "#" + pp2[5][1:]
    
    out_arr = []
    out_arr.append(dset_id)
    out_arr.append(path)
    out_arr.append(sz)
    out_arr.append("mod_time=" + ts)
    out_arr.append("checksum=" + checksum)
    out_arr.append("checksum_type=SHA256")

    print " | ".join(out_arr)

