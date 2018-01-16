import sys
from cmip6_cv import PrePARE
from cdms2 import Cdunif

import argparse
import re


def proc_path(path):


	cf = Cdunif.CdunifFile(path, 'r')

	try:
	    table = getattr(cf, 'table_id')
	except:
	    raise ESGPublishError("File %s missing required table_id global attribute"%f)

	try:
	    variable_id = getattr(cf, 'variable_id')
	except:
	    raise ESGPublishError("File %s missing required variable_id global attribute"%f)

	table_file = sys.argv[1] + '/CMIP6_' + table + '.json'
	fakeargs = [ '--variable', variable_id, table_file ,f]
	parser = argparse.ArgumentParser(prog='esgpublisher')
	parser.add_argument('--variable')
	parser.add_argument('cmip6_table', action=validator.JSONAction)
	parser.add_argument('infile', action=validator.CDMSAction)
	parser.add_argument('outfile',
	        nargs='?',
	        help='Output file (default stdout)',
	        type=argparse.FileType('w'),
	        default=sys.stdout)
	args = parser.parse_args(fakeargs)

	#        print "About to CV check:", f
	process = validator.checkCMIP6(args)

	args.infile = cf
	process.ControlVocab(args)
	args.infile.close()


def main():
	if len(sys.argv) < 2:
		print "usage <command> | python pptest_harness.py <cmor-table-path>"
		exit(0)

	for line in sys.stdin:

		proc_path(line.rstrip())


if (__name__ == '__main__'):


	main()

