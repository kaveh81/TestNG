from webservices.addDeleteCategory import Category
from webservices.addDeleteSeverity import Severity
from webservices.addDeletePriority import Priority
import invoker
from benchmark.bulk_webservices.deleteRecipients import DeleteRecipient

ADD_ALTERNATE_TEMPLATE=\
'''<addNewRecipients xmlns="http://www.mir3.com/ws">
  <apiVersion>2.19</apiVersion>
  <authorization>
    <username>%s</username>
    <password>%s</password>
  </authorization>
 <recipientDetail>
	<firstName>%s</firstName>
	<lastName>%s</lastName>
	<jobTitle>ENGINEER</jobTitle>
	<company>MIR3</company>
	<division>/</division>
	<employeeId>%s</employeeId>
  </recipientDetail>
  </addNewRecipients>'''

class BenchmarkSetup(object):
	def __init__(self, config):
		self.config=config
		self.prepare()

	def prepare(self):
		self.add_topics()
		self.add_alternate()

	def clean_up(self):
		self.delete_alternate()
		self.delete_topics()

	def add_topics(self):
		# create category 'Fire' , Priority 'Low' and Severity 'Critical'
		c=Category(self.config)
		c.create('Fire')
		p=Priority(self.config)
		p.create('Low')
		s=Severity(self.config)
		s.create('Critical')

	def delete_topics(self):
		# create category 'Fire' , Priority 'Low' and Severity 'Critical'
		c=Category(self.config)
		c.delete('Fire')
		p=Priority(self.config)
		p.delete('Low')
		s=Severity(self.config)
		s.delete('Critical')

	def add_alternate(self):		
		# create an alternate 'alternate-1'
		xml_request = ADD_ALTERNATE_TEMPLATE % (self.config['username'],self.config['password'], 'alternate-1'  , 'alternate', 'alternate-1')
		req = invoker.WSRequest(self.config)
		req.send(xml_request)
		response = req.parse()
		errors = response.get_errors()
		if len(errors)>0:
			response.print_errors()
		self.alternate_id = int(response.textForNode('userId'))
	
	def delete_alternate(self):
		# Delete alternate
		alternate_employee_id=['alternate-1']
		del_alternate = DeleteRecipient(self.config, 1)
		del_alternate.delete(alternate_employee_id, 'del_by_emp_id')

		



