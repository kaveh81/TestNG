import invoker, string

USERNAME='load'
PASSWORD='manager'
SEARCH_RECIPIENTS_TEMPLATE=\
'''<searchRecipients xmlns="http://www.mir3.com/ws">
  <apiVersion>2.19</apiVersion>
  <authorization>
    <username>%s</username>
    <password>%s</password>
  </authorization>
  <includeDetail>true</includeDetail>
  <query>
    <or>
	%s
	%s
    </or>
  </query>
</searchRecipients>'''

class SearchRecipients(object):
	def __init__(self, cfg):
		self.employeeIds = []
		self.userIds = []
		self.cfg = cfg

	def execute(self):
		req = invoker.WSRequest(self.cfg)
		req.send(self._to_xml())
		response = req.parse()
		errors = response.get_errors()
		if len(errors)>0:
			response.print_errors()
		else:
			return response

	def _to_xml(self):
		employeeId_str = string.join(['<employeeId>"%s"</employeeId>' % employeeId for employeeId in self.employeeIds])
		userId_str = string.join(['<userId>%d</userId>' % userId for userId in self.userIds])
		return SEARCH_RECIPIENTS_TEMPLATE % (self.cfg['username'],self.cfg['password'],employeeId_str,userId_str)

# Debug if run directly
if __name__=='__main__':
	s = SearchRecipients({'host':'dev01.mir3.com','port':'80','username':'webserviceAdmin','password':'webserviceAdmin'})
	s.employeeIds = ['z-dude-%d' % num for num in xrange(2)]
	print s.execute().get_raw_response()
