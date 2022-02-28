import requests, json, sys

NUM_RETR = 10000

def print_func2(n):
	print(n["instance_id"], n["number_of_files"]) 


def print_func(n):
	print(n["instance_id"])

inst_id = "MOHC"

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
                
                print("resp found: {}".format(numfound))

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

                print('listlen: {}'.format(len(resp["response"]["docs"])))
		for n in resp["response"]["docs"]:
			pf(n)





constraints = f"project=CMIP6&institution_id={inst_id}"


if sys.argv[1] == "R":  # retracted original data

	search_url = "http://esgf-node.llnl.gov/esg-search/search?{}&replica=false&retracted=true&limit={}&offset={}&format=application%2fsolr%2bjson&fields=instance_id"


elif sys.argv[1] == "V":  # old versions of original data

	search_url = "http://esgf-node.llnl.gov/esg-search/search?{}&replica=false&latest=false&retracted=false&limit={}&offset={}&format=application%2fsolr%2bjson&fields=instance_id"

elif sys.argv[1] == "L":  # latest replicas at LLNL
	data_node = sys.argv[2]
	search_url = "http://esgf-node.llnl.gov/esg-search/search?{}&replica=true&latest=true&limit={}&offset={}&data_node="+data_node+".llnl.gov&format=application%2fsolr%2bjson&fields=instance_id,number_of_files"

elif sys.argv[1] == "O":  # latest original data
	search_url = "http://esgf-node.llnl.gov/esg-search/search?{}&replica=false&latest=true&limit={}&offset={}&format=application%2fsolr%2bjson&fields=instance_id,number_of_files"

else:
	exit(1)

print_dsets(search_url)

