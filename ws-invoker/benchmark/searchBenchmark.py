#!/usr/bin/python
import os.path
import sys

base_dir = os.path.join(os.path.dirname(sys.argv[0]), '..')
sys.path.append(base_dir)

from webservices.searchRecipients import SearchRecipients
from webservices.addNewRecipients import Recipient
from optparse import OptionParser
import invoker
from benchmark.runBenchmark import run_benchmark
from benchmark.runBenchmark import add_blank_line

confirmedEmployeeIds = {}
HUGE_SIZE_EMPLOYEE_IDS = ['z-benchmark-%d' % num for num in range(1000)]
LARGE_SIZE_EMPLOYEE_IDS = ['z-benchmark-%d' % num for num in range(100)]
LARGE_SIZE_USER_IDS = []
SMALL_SIZE_EMPLOYEE_IDS = ['z-benchmark-%d' % num for num in range(23,24)]
SMALL_SIZE_USER_IDS = []


def create_missing_recipients(employeeIds):
	for employeeId in employeeIds:
		if confirmedEmployeeIds.has_key(employeeId):
			continue
		search = SearchRecipients(config)
		search.employeeIds.append(employeeId)
		response = search.execute()
		matchCount = response.textForNode('matchCount')
		if matchCount == '0':
			if options.createRecipients:
				print 'Need to create %s ... ' % employeeId,
				r = Recipient(config)
				r.firstName = 'benchmark-%s' % employeeId
				r.lastName = 'z-benchmark'
				r.role = 'Recipient'
				r.employeeId = employeeId
				print 'Created new recipient with ID %d' % r.create()
			else:
				raise Error('No recipient with employee ID %s' % employeeId)
		elif matchCount == '1':
			#print 'Verified %s exists' % employeeId
			confirmedEmployeeIds[employeeId] = int(response.textForNode('userId'))
		elif matchCount != '1':
			print 'Unexpected match count: %s' % matchCount
		
# First look up the user id's for these employee ID's, then benchmark the search for them
def search_user_ids(employeeIds):
	create_missing_recipients(employeeIds)
	search = SearchRecipients(config)
	search.userIds = [confirmedEmployeeIds[eid] for eid in employeeIds]
	resp = search.execute()
	matchCount = int(resp.textForNode('matchCount'))
	if matchCount != len(employeeIds):
		raise ValueError('Unexpected number of responses')
	return resp.get_elapsed_time()
	
def search_employee_ids(employeeIds):
	if options.createRecipients: create_missing_recipients(employeeIds)
	search = SearchRecipients(config)
	search.employeeIds = employeeIds
	resp = search.execute()
	matchCount = int(resp.textForNode('matchCount'))
	if matchCount != len(employeeIds):
		raise ValueError('Unexpected number of responses, got %d but expected %d' % (len(employeeIds), matchCount))
	return resp.get_elapsed_time()
	
def benchmarkLargeUID():
	return search_user_ids(LARGE_SIZE_EMPLOYEE_IDS)

def benchmarkSmallUID():
	return search_user_ids(SMALL_SIZE_EMPLOYEE_IDS)

def benchmarkHugeEID():
	return search_employee_ids(HUGE_SIZE_EMPLOYEE_IDS)

def benchmarkLargeEID():
	return search_employee_ids(LARGE_SIZE_EMPLOYEE_IDS)

def benchmarkSmallEID():
	return search_employee_ids(SMALL_SIZE_EMPLOYEE_IDS)

def parseConfig():
	global config
	if len(args) != 1: raise ValueError('Exactly one config file must be specified')
	config = invoker.read_config(args[0])

def main():
	global options, args
	parser = OptionParser(usage="usage: %prog [options] config_file")
	parser.add_option("-c", "--create-recipients", dest="createRecipients", action="store_true", default=False, \
		help="Whether to check that the recipients used in the benchmark exist, and create them if not present")
	parser.add_option("-r", "--record", dest="recordComment",  \
		help="Record the results of this run, with the specified comment")
	parser.add_option("-f", "--config-file", dest="config_file", help="A config file to set options")
	(options, args) = parser.parse_args()
	parseConfig()
	add_blank_line()
	run_benchmark('Search 1000 users by employee ID', benchmarkHugeEID, 10, options)
	run_benchmark('Search 100 users by employee ID', benchmarkLargeEID, 10, options)
	run_benchmark('Search 100 users by user ID', benchmarkLargeUID, 10, options)
	run_benchmark('Search 1 user by employee ID', benchmarkSmallEID, 200, options)
	run_benchmark('Search 1 user by user ID', benchmarkSmallUID, 200, options)
	print 'Search Recipient Benchmarking done!'

if __name__=='__main__': main()
