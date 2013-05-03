import invoker
import sys

ADD_RECIPIENT_TEMPLATE=\
'''<addNewRecipients xmlns="http://www.mir3.com/ws">
  <apiVersion>2.19</apiVersion>
  <authorization>
    <username>%s</username>
    <password>%s</password>
  </authorization>
  <recipientDetail>
    <firstName>%s</firstName>
    <lastName>%s</lastName>
    <jobTitle>%s</jobTitle>
    <role>%s</role>
    <devices>
      <device>
        <deviceType>Work Phone</deviceType>
        <address>858-724-1244</address>
      </device>
    </devices>
	<employeeId>%s</employeeId>
  </recipientDetail>
</addNewRecipients>'''

class Recipient(object):
	def __init__(self, cfg):		
		self.userId = -1
		self.firstName = 'first name'
		self.lastName = 'last name'
		self.jobTitle = 'job title'
		self.role = 'Recipient'
		self.employeeId = None
		self.cfg=cfg	

	def create(self):
		req = invoker.WSRequest(self.cfg)
		req.send(self._to_add_xml())
		response = req.parse()
		errors = response.get_errors()
		if len(errors)>0:
			response.print_errors()
		self.userId = int(response.textForNode('userId'))
		return self.userId

	def _to_add_xml(self):
		employeeId_str = ''
		if self.employeeId != None: employeeId_str = '<employeeId>%s</employeeId>' % self.employeeId
		return ADD_RECIPIENT_TEMPLATE % (self.cfg['username'],self.cfg['password'],self.firstName, self.lastName, self.jobTitle, self.employeeId, self.role)

if __name__=='__main__':
	print sys.path
	for i in range(1000):
		cfg = invoker.read_config(sys.argv[1])
		r = Recipient(cfg)
		r.firstName = '%d' % i
		r.lastName = 'Z-Dude'
		r.employeeId = 'z-dude-%d' % i
		r.create()
		print 'Created user %d with ID %d' % (i+1, userId)
