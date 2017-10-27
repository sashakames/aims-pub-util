import json, sys

obj = json.load(open(sys.argv[1]))


basic_facets = ["project", "institution_id", "data_type", "target_mip", "time_frequency", "source", "variable_id", "grid_label"]


dset_arr =[]
attr_arr = []


for key in basic_facets:
	dset_arr.append(obj[key])

for key in obj:

	if not key in basic_facets + ["license"]:

		attr_arr.append(key + '=' + obj[key])


dset = '.'.join(dset_arr)

print ' | '.join([dset] + attr_arr)


