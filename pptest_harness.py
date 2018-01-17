import sys
from cmip6_cv import PrePARE
from cdms2 import Cdunif

import argparse
import re


def proc_path(validator, path):


	cf = Cdunif.CdunifFile(path, 'r')

	table = ''

	try:
	    table = getattr(cf, 'table_id')
	except:
	    raise ESGPublishError("File %s missing required table_id global attribute"%f)
	variable_id =''
	try:
	    variable_id = getattr(cf, 'variable_id')
	except:
	    raise ESGPublishError("File %s missing required variable_id global attribute"%f)


	table_file = sys.argv[1] + '/CMIP6_' + table + '.json'

	print path, variable_id, table_file

	fakeargs = [ '--variable', variable_id, table_file , path]
	parser = argparse.ArgumentParser(prog='pptest_harness')
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
	try:
		process.ControlVocab(args)
	except KeyboardInterrupt as e:
		print "Error with ",path, str(e)
	args.infile.close()


def main():
	if len(sys.argv) < 2:
		print "usage <command> | python pptest_harness.py <cmor-table-path>"
		exit(0)

	for line in sys.stdin:

		proc_path(PrePARE.PrePARE  , line.rstrip())


if (__name__ == '__main__'):


	main()

