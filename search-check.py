import requests, json, sys

NUM_RETR = 10000

def print_func2(n):
	print(n["instance_id"], n["number_of_files"]) 


def print_func(n):
	print(n["instance_id"])



def print_dsets(search_url):

	going = True

	offset = 0
	togo = 0
	pf = print_func 
	if len(sys.argv) > 2 and sys.argv[2] == "F" :
		pf = print_func2

	while going:
		resp = json.loads(requests.get(search_url.format(NUM_RETR, offset)).text)

		numfound = resp["response"]["numFound"]

		if togo == 0:
			if numfound > NUM_RETR:

				togo = numfound - NUM_RETR
				offset = offset + NUM_RETR
			else:
				going = False
		else:
			togo = togo - NUM_RETR
			offset = offset + NUM_RETR

			if togo < 1:
				going = False

		for n in resp["response"]["docs"]:
			pf(n)





if sys.argv[1] == "R":  # retracted original data

	search_url = "http://esgf-node.llnl.gov/esg-search/search?project=CMIP6&replica=false&retracted=true&limit={}&offset={}&format=application%2fsolr%2bjson&fields=instance_id"


elif sys.argv[1] == "V":  # old versions of original data

	search_url = "http://esgf-node.llnl.gov/esg-search/search?project=CMIP6&replica=false&latest=false&retracted=false&limit={}&offset={}&format=application%2fsolr%2bjson&fields=instance_id"

elif sys.argv[1] == "L":  # latest replicas at LLNL
	data_node = sys.argv[2]
	search_url = "http://esgf-node.llnl.gov/esg-search/search?project=CMIP6&replica=true&latest=true&limit={}&offset={}&data_node={}&format=application%2fsolr%2bjson&fields=instance_id,number_of_files".format(data_node)

elif sys.argv[1] == "O":  # latest original data
	search_url = "http://esgf-node.llnl.gov/esg-search/search?project=CMIP6&replica=false&latest=true&limit={}&offset={}&format=application%2fsolr%2bjson&fields=instance_id,number_of_files"

else:
	exit(1)

print_dsets(search_url)

