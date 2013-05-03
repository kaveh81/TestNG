#!/usr/bin/python
import os.path
import sys

base_dir = os.path.join(os.path.dirname(sys.argv[0]), '..')
sys.path.append(base_dir)

from benchmark.bulk_webservices.deleteRecipients import DeleteRecipient
from benchmark.bulk_webservices.updateRecipients import UpdateRecipient
from benchmark.bulk_webservices.addNewRecipients import Recipient
from benchmark.runBenchmark import run_benchmark
from benchmark.runBenchmark import add_blank_line
from benchmark.benchmarkSetup import BenchmarkSetup
from optparse import OptionParser
import invoker

class InsertUpdateDeleteBenchmark(object):
	def __init__(self, config):
		self.config = config		
		self.newly_created_user_ids = []				

		# if the user has specified batch size option then use it or use the default list
		if options.batch_size != None:
			self.default_benchmark_user_batch_size = [options.batch_size]
		else:
		    self.default_benchmark_user_batch_size = [1, 5, 10, 50, 100, 500]
			
		#setup the organization for tests by adding required topics and alternate
		self.setup = BenchmarkSetup(self.config)		
		
	def batch_add_recipients(self, del_users=True):
		"""
		   returns the time required to add a batch of recipients in the inEnterprise system
		"""
		# clear the entire list to remove any values from previous run_benchmark
		del self.newly_created_user_ids[:]
		
		r = Recipient(self.config, self.batch_size)
		elapsed_time = r.create_batch()
		self.newly_created_user_ids = r.get_user_ids()
		if del_users:
			self.delete_newly_created_users()
		return elapsed_time

	def update_newly_created_recipients(self):
		update_recipients = UpdateRecipient(self.config, self.batch_size)
		users_to_be_updated = list(self.newly_created_user_ids)
		elapsed_time = update_recipients.update(users_to_be_updated)
		return elapsed_time

	def batch_update_recipients(self):
		self.batch_add_recipients(False)		
		elapsed_time = self.update_newly_created_recipients()		
		self.delete_newly_created_users()
		return elapsed_time

	def delete_newly_created_users(self):
		delete_time=0		
		if len(self.newly_created_user_ids) > 0:
			delRep = DeleteRecipient(self.config, self.batch_size)
			delete_time = delRep.delete(self.newly_created_user_ids)
			# clear the entire list
			del self.newly_created_user_ids[:]
		else:
			pass
		return delete_time

	def batch_delete_recipients(self):
		self.batch_add_recipients(False)
		return self.delete_newly_created_users()

	def benchmark_inserts(self):
		self.benchmark('Add', self.batch_add_recipients)

	def benchmark_updates(self):
		self.benchmark('Update', self.batch_update_recipients)
		
	def benchmark_deletes(self):
		self.benchmark('Delete', self.batch_delete_recipients)

	def benchmark(self, benchmark_op, batch_fun):		
		for self.batch_size in self.default_benchmark_user_batch_size:			
			run_benchmark('%s a batch of recipients with batch size %d'%(benchmark_op,  self.batch_size), batch_fun, options.iterations, options)
		
	def clean_up(self):
		self.setup.clean_up()
					
def parse_config():
		if len(args) != 1: raise ValueError('Exactly one config file must be specified')
		return invoker.read_config(args[0])

def main():
	global options, args
	
	parser = OptionParser(usage="usage: %prog [options] config_file. If no option is specified then program will benchmark insert, update and delete recipients only")
	parser.add_option("-r", "--record", dest="record_comment",  \
		help="Record the results of this run, with the specified comment")
	parser.add_option("-i", action="store_true", dest="benchmark_inserts", default=False,  \
		help="Benchmark insert recipients")
	parser.add_option("-u", action="store_true", dest="benchmark_updates", default=False, \
		help="Benchmark update recipients")
	parser.add_option("-d", action="store_true", dest="benchmark_deletes",  default=False,\
		help="Benchmark delete recipients")
	parser.add_option("-b", "--batch_size", type=int, dest="batch_size", help="Batch size for insert, update or delete operation")
	parser.add_option("-I", type=int, dest="iterations", help="Number of iterations", default=1 )
	parser.add_option("-f", "--config-file", dest="config_file", help="A config file to set options")
	(options, args) = parser.parse_args()
	config=parse_config()
		
	iud=InsertUpdateDeleteBenchmark(config)
	add_blank_line()
	
	# If options -i -u or -d not specified then run benchmark test for all insert, update and delete
	if options.benchmark_inserts == False and options.benchmark_updates == False and options.benchmark_deletes == False:
		iud.benchmark_inserts()
		iud.delete_newly_created_users()
		iud.benchmark_updates()
		iud.benchmark_deletes()

	if options.benchmark_inserts == True:
		iud.benchmark_inserts()
		iud.delete_newly_created_users()
	if options.benchmark_updates == True:
		iud.benchmark_updates()
	if options.benchmark_deletes == True:
		iud.benchmark_deletes()

	# Clean up the data added for tests like topics and alternate
	iud.clean_up()

	print 'Benchmarking bulk add, update and/or delete recipients done!'

if __name__=='__main__': main()
