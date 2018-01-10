import json, sys

obj = json.load(open(sys.argv[1]))


basic_facets = ["mip_era", "activity_id", "target_mip",  "institution_id", "realm", "frequency", "source_id", "variable_id", "grid_label"]


dset_arr =[]
attr_arr = []


for key in basic_facets:
	dset_arr.append(obj[key])

for key in obj:

	if not key in basic_facets + ["license"]:

		attr_arr.append(key + '=' + obj[key])


dset = '.'.join(dset_arr)

print ' | '.join([dset] + attr_arr)


