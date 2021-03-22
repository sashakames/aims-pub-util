import requests, json, os, sys

NUM_RETR = 10000
VERBOSE = False
SEARCH_TEMPLATE = "http://esgf-node.llnl.gov/esg-search/search?project=CMIP6&distrib=false&replica=true&latest=false&retracted=false&limit={}&offset={}&format=application%2fsolr%2bjson&fields=id"


def get_dsets(search_url):
    going = True

    offset = 0
    togo = 0

    out = []

    while going:

        resp = requests.get(search_url.format(NUM_RETR, offset)).text
        jsonresp = json.loads(resp)

        numfound = jsonresp["response"]["numFound"]

        if VERBOSE:
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
                if VERBOSE:
                    print('listlen: {}'.format(len(jsonresp["response"]["docs"])))
        out = out + jsonresp["response"]["docs"]
    return out


def main():
    resp = get_dsets(SEARCH_TEMPLATE)

    print(json.dumps(resp, indent=1))


if __name__ == '__main__':
    sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.realpath(__file__))))
    main()
