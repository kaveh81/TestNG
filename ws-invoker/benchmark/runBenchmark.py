#!/usr/bin/python
import sys
import csv
from datetime import datetime

RECORD_FILE = 'benchmark/benchmark-results.csv'
STAMP = datetime.now().isoformat()

def run_benchmark(description, func, iterations, options):
	total_time = 0
	print 'Running %s' % description,
	sys.stdout.flush()
	min_time = 10000000.0
	max_time = 0.0
	options=options
	
	# Run once to prime the pump
	func()
	for i in range(iterations):
		result = func()
		print result
		if result < min_time: min_time = result
		if result > max_time: max_time = result
		total_time += result
		print 'Run %d completed in %.2f' % (i, result)
	print ' total time: %.2fs for %d iterations' % (total_time, iterations)

	# Record results in the results file	
	if options.record_comment != None:
		f = open(RECORD_FILE, 'a+')
		writer = csv.writer(f)
		writer.writerow([description,total_time,iterations,min_time,max_time,STAMP,options.record_comment])

def add_blank_line():
		f = open(RECORD_FILE, 'a+')
		writer = csv.writer(f)
		writer.writerow([])

