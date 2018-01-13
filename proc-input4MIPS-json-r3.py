import os, json, sys  #, cdms2

attr_list_fn = sys.argv[1]
attr_key_lst = []

for line in open(attr_list_fn):
	attr_key_lst.append(line.rstrip())

path_prefix = sys.argv[2]  #where the file is...

for fn in sys.stdin:

	baseobj=json.load(open(fn.rstrip()))
	
	keylst = baseobj.keys()
	obj=baseobj[keylst[0]]
#	os.rename(fn, fn+".old")

	# get file name

	        # "file_list":[
	        #     "CMIP6/input4MIPs/IACETH/aerosolProperties/CMIP/mon/atmos/IACETH-SAGE3lambda-3-0-0/multiple/gn/v20171006/multiple_input4MIPs_aerosolProperties_CMIP_IACETH-SAGE3lambda-3-0-0_gn_185001_201412.nc"
	nc_fn = ""
	if "file" in obj.keys():
		nc_fn =  obj["file"]
	else:
		nc_fn =  obj["file_list"][0]
	

	#get path list

	DRS_list = nc_fn.split('/')

	# open file

	#openpath = nc_fn.replace('CMIP6', path_prefix)

	# convert path to DRS dataset_id

	parts = nc_fn.split('/')


	#TODO - change this for new DRS ala Karl
#	DRS = parts[1:6] + parts[7:10] # skip mip era and realm

	DRS = parts[0:9]
	 
	fn = parts[-1]


	# get attribute list
	dataset_id = '.'.join(DRS)
	atr_arr = [dataset_id]  # output array


	for baseattr in attr_key_lst:
		# extract from json
		value = ""
		out_attr = ""
		attr = ""  # this is the global attr or json key

		if ':' in baseattr:
			aparts = baseattr.split(':')
			attr = aparts[0]
			out_attr = aparts[1]
		else:
			attr = baseattr
			out_attr = baseattr
		if attr in obj:
			value = obj[attr]	

		# extract from global attributes (missing ones only)

		# write back to file (future work TODO)
		
		outvalue = value
		if type(value) is list :
			outvalue = ','.join(value)
		
		if len(outvalue) > 0:
			
			atr_arr.append(out_attr + '=' + outvalue)

	# write out map format dataset_id | key=value | ...

	print ' | '.join(atr_arr)



